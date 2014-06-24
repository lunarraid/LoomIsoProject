package com.lunarraid.isoproject.view
{
    import loom2d.textures.Texture;
    import loom2d.display.Image;
    import loom2d.display.DisplayObject;
    import loom2d.display.Sprite;
    
    import com.lunarraid.isoproject.math.Point3;
    
    import loom2d.ui.TextureAtlasSprite;
    
    public class ProjectedAtlasSpriteRenderer extends ProjectedViewRenderer
    {
        //--------------------------------------
        // PRIVATE / PROTECTED
        //--------------------------------------

        protected var _atlasName:String;
        protected var _textureName:String;
        protected var _textureAtlasSprite:TextureAtlasSprite;
        
        //--------------------------------------
        //  GETTERS / SETTERS
        //--------------------------------------
        
        public function get atlasName():String { return _atlasName; }
        
        public function set atlasName( value:String ):void
        {
            _atlasName = value;
            if ( _textureAtlasSprite )
            {
                _textureAtlasSprite.atlasName = value;
                updateOrigin();
            }
        }
        
        public function get textureName():String { return _textureName; }
        
        public function set textureName( value:String ) :void
        {
            _textureName = value;
            if ( _textureAtlasSprite )
            {
                _textureAtlasSprite.textureName = value;
                updateOrigin();
            }
        }
        
        //--------------------------------------
        //  CONSTRUCTOR
        //--------------------------------------
        
        public function ProjectedAtlasSpriteRenderer( atlasName:String, textureName:String )
        {
            _atlasName = atlasName;
            _textureName = textureName;
            super();
        }
        
        //--------------------------------------
        //  PRIVATE / PROTECTED METHODS
        //--------------------------------------
        
        override protected function createDisplayObject():DisplayObject
        {
            _textureAtlasSprite = new TextureAtlasSprite();
            if ( _atlasName ) _textureAtlasSprite.atlasName = _atlasName;
            if ( _textureName ) _textureAtlasSprite.textureName = _textureName;
            return _textureAtlasSprite;
        }
    }
}