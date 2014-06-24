package loom2d.tmx
{
    import loom2d.tmx.TMXDocument;
    import loom2d.tmx.TMXTileset;
    import loom2d.tmx.TMXLayer;
    
    import loom2d.display.QuadBatch;
    import loom2d.display.Image;
    import loom2d.textures.Texture;
    import loom2d.math.Rectangle;
    
    import system.xml.XMLDocument;

    public class TMXMapQuadBatch extends QuadBatch
    {
        private var _tileWidth:Number;
        private var _tileHeight:Number;
        private var _orthogonal:Boolean;
        private var _isometric:Boolean;
        private var _gidOffset:int = 0;
        private var _tileTextures:Vector.<Texture>;
        private var _tmx:TMXDocument;

        public function TMXMapQuadBatch( tmx:TMXDocument )
        {
            super();
            _tmx = tmx;
            tmx.onTMXLoadComplete += onTMXLoadComplete;
            if ( tmx.version > 0 ) onTMXLoadComplete( "", tmx );
        }
        
        
        override public function dispose():void
        {
            _tmx.onTMXLoadComplete -= onTMXLoadComplete;
            super.dispose();
        }

        private function onTMXLoadComplete( file:String, tmx:TMXDocument ):void
        {
            _tileWidth = tmx.tileWidth;
            _tileHeight = tmx.tileHeight;
            _orthogonal = tmx.orientation == "orthogonal";
            _isometric = tmx.orientation == "isometric";
            
            reset();
            
            // Get our GID offset and tileset by finding the tileset for the first rendered tile
            
            _gidOffset = 1;
            
            Debug.assert( tmx.tilesets.length > 0, "No Tilesets Found in TMX Document" );
            var activeTileset:TMXTileset = tmx.tilesets[ 0 ];
            
            if ( tmx.tilesets.length > 1 )
            {
                var firstRenderedGid:int = getFirstRenderedTileGid( tmx );
                
                for ( var i:int = 0; i < tmx.tilesets.length; i++ )
                {
                    var tileset:TMXTileset = tmx.tilesets[ i ];
                    if ( firstRenderedGid >= tileset.firstgid && firstRenderedGid < tileset.firstgid + tileset.tiles.length )
                    {
                        _gidOffset = tileset.firstgid;
                        activeTileset = tmx.tilesets[ i ];
                        break;
                    }
                }
            }
            
            _tileTextures = createTextures( activeTileset );
            
            for ( var j:int = 0; j < tmx.layers.length; j++ ) renderLayer( tmx.layers[ j ] );
            
            if ( tmx.imageLayers.length > 0 ) trace( "Skipping image layers, not supported in QuadBatch" );
        }
        
        private function getFirstRenderedTileGid( tmx:TMXDocument ):int
        {
            for ( var i:int = 0; i < tmx.layers.length; i++ )
            {
                for ( var j:int = 0; j < tmx.layers[ i ].tiles.length; j++ )
                {
                    var gid:int = tmx.layers[ i ].tiles[ j ];
                    if ( gid > 0 ) return gid;
                }
            }
            
            return 0;
        }
        
        private function createTextures( tileset:TMXTileset ):Vector.<Texture>
        {
            var result:Vector.<Texture> = [];
            var texture:Texture = Texture.fromAsset( tileset.image.source );
            
            var numRows:int = Math.floor( ( texture.height - tileset.margin ) / ( tileset.tilewidth + tileset.spacing ) );
            var numCols:int = Math.floor( ( texture.width - tileset.margin ) / ( tileset.tileheight + tileset.spacing ) );
 
            var textureRect:Rectangle = new Rectangle( 0, 0, tileset.tilewidth - 0.5, tileset.tileheight - 0.5 );

            for (var i:int = 0; i < numRows; i++)
            {
                for (var j:int = 0; j < numCols; j++)
                {
                    textureRect.x = tileset.margin + 0.5 + ( j * tileset.tilewidth ) + ( j * tileset.spacing );
                    textureRect.y = tileset.margin + 0.5 + ( i * tileset.tileheight ) + ( i * tileset.spacing );
                    result.push( Texture.fromTexture( texture, textureRect ) );
                }
            }
            
            return result;
        }
        
        private function renderLayer( layer:TMXLayer ):void
        {
            const FLIPPED_HORIZONTALLY_FLAG:uint = 0x80000000;
            const FLIPPED_VERTICALLY_FLAG:uint = 0x40000000;
            const FLIPPED_DIAGONALLY_FLAG:uint = 0x20000000;
            var flipped_horizontally:Boolean = false;
            var flipped_vertically:Boolean = false;
            var flipped_diagonally:Boolean = false;

            var x:int = 0;
            var y:int = 0;
            var gid:uint = 0;
            
            // Create an image with default texture since you can't specify null
            var tileImage:Image = new Image( Texture.fromAsset( "assets/tile.png" ) );
            tileImage.alpha = layer.opacity;
            tileImage.visible = layer.visible;
            
            for ( y = 0; y < layer.height; y++ )
            {
                for ( x = 0; x < layer.width; x++ )
                {
                    gid = layer.tiles[(y * layer.width) + x];
                    
                    flipped_horizontally = (gid & FLIPPED_HORIZONTALLY_FLAG) != 0;
                    flipped_vertically = (gid & FLIPPED_VERTICALLY_FLAG) != 0;
                    flipped_diagonally = (gid & FLIPPED_DIAGONALLY_FLAG) != 0;
                    
                    gid &= ~(FLIPPED_HORIZONTALLY_FLAG | FLIPPED_VERTICALLY_FLAG | FLIPPED_DIAGONALLY_FLAG);
                    
                    if ( gid == 0 ) continue;
                    
                    gid -= _gidOffset;
                    Debug.assert( gid >= 0 && gid < _tileTextures.length, "Multiple textures are not supported using a QuadBatch " + gid + " " + _tileTextures.length );
                    
                    tileImage.texture = _tileTextures[ gid ];
                    
                    if(_isometric)
                    {
                        tileImage.x = x * _tileWidth/2 - y * _tileWidth/2;
                        tileImage.y = x * _tileHeight/2 + y * _tileHeight/2;
                    }
                    else
                    {
                        tileImage.x = x * _tileWidth;
                        tileImage.y = y * _tileHeight;

                        //These flipped values only work for orthogonal maps
                        if(flipped_vertically && flipped_horizontally && flipped_diagonally)
                        {
                            tileImage.rotation = 90 * Math.PI / 180;
                            tileImage.x = x * _tileWidth + _tileWidth;
                        }
                        else if(flipped_vertically && flipped_horizontally)
                        {
                            tileImage.scaleX = tileImage.scaleY = -1;
                            tileImage.x = x * _tileWidth + _tileWidth;
                            tileImage.y = y * _tileHeight + _tileHeight;    
                        }
                        else if(flipped_vertically && flipped_diagonally)
                        {
                            tileImage.rotation = -90 * Math.PI / 180;
                            tileImage.y = y * _tileHeight + _tileHeight;
                        }
                        else if(flipped_horizontally && flipped_diagonally)
                        {
                            tileImage.rotation = 90 * Math.PI / 180;
                            tileImage.x = x * _tileWidth + _tileWidth;
                        }
                        else if (flipped_horizontally)
                        {
                            tileImage.scaleX = -1;
                            tileImage.x = x * _tileWidth + _tileWidth;
                        }
                        else if (flipped_vertically)
                        {
                            tileImage.scaleY = -1;
                            tileImage.y = y * _tileHeight + _tileHeight;
                        }
                    }

                    addQuad( tileImage );
                }
            }
        }
    }
}