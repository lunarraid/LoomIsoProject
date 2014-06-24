package com.lunarraid.isoproject.group
{
    import loom2d.display.DisplayObject;
    import loom2d.display.Sprite;
	import loom2d.math.Rectangle;
	
    import loom2d.tmx.TMXDocument;
    import loom2d.tmx.TMXObjectGroup;
    import loom2d.tmx.TMXObject;
    import loom2d.tmx.TMXRectangle;
    import loom2d.tmx.TMXMapQuadBatch;
    
    import loom2d.ui.TextureAtlasManager;
    
    import loom.gameframework.LoomGroup;
    import loom.gameframework.LoomGameObject;
    
    import com.lunarraid.isoproject.view.ProjectedViewManager;
    import com.lunarraid.isoproject.view.ProjectedAtlasSpriteRenderer;
    import com.lunarraid.isoproject.view.projection.IsoProjection;
    
    public class TiledMapGroup extends LoomGroup
    {
        //--------------------------------------
        // PRIVATE / PROTECTED
        //--------------------------------------
        
        private static const TMX_PATH:String = "assets/tmx/map.tmx";
        private static const SPRITESHEET_PATH:String = "assets/spritesheets/objects.xml";
        private static const SPRITESHEET_ID:String = "objects";
        
        //--------------------------------------
        // PRIVATE / PROTECTED
        //--------------------------------------
        
        private var _mapDisplay:TMXMapQuadBatch;
        private var _tmxData:TMXDocument;
        private var _viewComponent:Sprite;
        
        //--------------------------------------
        //  GETTERS / SETTERS
        //--------------------------------------
        
        public function get viewComponent():DisplayObject { return _viewComponent; }
        
        //--------------------------------------
        //  PUBLIC METHODS
        //--------------------------------------
        
        override public function initialize( name:String = "TiledMapGroup" ):void
        {
            super.initialize( name );
            
            _viewComponent = new Sprite();
            
            // Register our spritesheet
            TextureAtlasManager.register( SPRITESHEET_ID, SPRITESHEET_PATH );
            
            // Load in our map file
            _tmxData = new TMXDocument( TMX_PATH );
            _mapDisplay = new TMXMapQuadBatch( _tmxData );
            _tmxData.load();
            
            // Register our view manager, and give it the tile width from the tmx file
            // Note: The isometric projection assumes that the tile height is half of
            // the tile width. The tmx file tile height is ignored.
            
            var projection:IsoProjection = new IsoProjection();
            projection.tileWidth = _tmxData.tileWidth;
            var viewManager:ProjectedViewManager = new ProjectedViewManager( projection );
            registerManager( viewManager );
            
            _mapDisplay.x = -_tmxData.tileWidth * 0.5;
            
            _viewComponent.addChild( _mapDisplay );
            _viewComponent.addChild( viewManager.viewComponent );
            
            // Spawn all of our game objects!
            
            var objects:Vector.<TMXObject> = _tmxData.objectGroups[ 0 ].objects;
            var objectCount:int = objects.length;
            
            for ( var i:int = 0; i < objectCount; i++ )
            {
                var tmxObject:TMXObject = objects[ i ];
                
                var gameObject:LoomGameObject = new LoomGameObject();
                gameObject.initialize( tmxObject.name );
                gameObject.owningGroup = this;
                
                // The names of the images in the spritesheet match the 'type' of the TMXObject,
                // so we use the type property to create a new renderer with the correct image.
                var renderer:ProjectedAtlasSpriteRenderer = new ProjectedAtlasSpriteRenderer( SPRITESHEET_ID, tmxObject.type );
                gameObject.addComponent( renderer, "renderer" );
                
                // Tiled Map Editor stores object bounds in a bizarre way, so do some math to
                // spawn our object at the correct isometric coordinates
                renderer.x = tmxObject.x / _tmxData.tileWidth * 2;
                renderer.y = tmxObject.y / _tmxData.tileHeight;
                
                // Adjust positions based on rectangle size
                var tmxRect:TMXRectangle = tmxObject as TMXRectangle;
                if ( tmxRect )
                {
                    renderer.x += ( tmxRect.width / _tmxData.tileWidth * 2 );
                    renderer.y += ( tmxRect.height / _tmxData.tileHeight );
                }
            }
        }
        
        //--------------------------------------
        //  PRIVATE / PROTECTED METHODS
        //--------------------------------------
    }
}