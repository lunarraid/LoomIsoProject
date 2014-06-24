package com.lunarraid.isoproject.view
{
	import loom2d.math.Point;
    import loom2d.display.DisplayObject;
    import loom.gameframework.AnimatedComponent;
    import com.lunarraid.isoproject.math.Point3;
    
    public class ProjectedViewRenderer extends AnimatedComponent
    {
        //--------------------------------------
        // DEPENDENCIES
        //--------------------------------------
        
        [Inject]
        public var viewManager:ProjectedViewManager;
        
        //--------------------------------------
        // PRIVATE / PROTECTED
        //--------------------------------------

        protected var _viewComponent:DisplayObject;
        protected var _position:Point3;
        protected var _scratchPoint:Point3;
        protected var _originX:Number = 0.5;
        protected var _originY:Number = 1;
        
        //--------------------------------------
        //  CONSTRUCTOR
        //--------------------------------------
        
        public function ProjectedViewRenderer()
        {
            _viewComponent = createDisplayObject();
            updateOrigin();
        }
        
        //--------------------------------------
        //  GETTER/SETTERS
        //--------------------------------------
        
        public function get viewComponent():DisplayObject { return _viewComponent; }
        
        public function get x():Number { return _position.x; }
        
        public function set x( value:Number ):void
        {
            if ( _position.x == value ) return;
            _position.x = value;
            updatePosition();
        }
        
        public function get y():Number { return _position.y; }

        public function set y( value:Number ):void
        {
            if ( _position.y == value ) return;
            _position.y = value;
            updatePosition();
        }

        public function get z():Number { return _position.z; }
        
        public function set z( value:Number ):void
        {
            if ( _position.z == value ) return;
            _position.z = value;
            updatePosition();
        }
        
        public function get originX():Number { return _originX; }
        
        public function set originX( value:Number ):void
        {
            if ( _originX == value ) return;
            _originX = value;
            updateOrigin();
        }
        
        public function get originY():Number { return _originY; }
        
        public function set originY( value:Number ):void
        {
            if ( _originY == value ) return;
            _originY = value;
            updateOrigin();
        }
        
        //--------------------------------------
        //  PUBLIC METHODS
        //--------------------------------------
        
        override public function onAdd():Boolean
        {
            if ( !super.onAdd() ) return false;
            viewManager.addChild( this );
            return true;
        }
        
        override public function onRemove():void
        {
            viewManager.removeChild( this );
            if ( _viewComponent ) _viewComponent.dispose();
            _viewComponent = null;
            super.onRemove();
        }
        
        public function updatePosition():void
        {
            if ( !viewManager ) return;
            _scratchPoint = viewManager.project( _position );
            _viewComponent.x = _scratchPoint.x;
            _viewComponent.y = _scratchPoint.y;
            _viewComponent.depth = _scratchPoint.z * 100 - _position.z;
        }
        
        //--------------------------------------
        //  PRIVATE / PROTECTED METHODS
        //--------------------------------------
        
        protected function createDisplayObject():DisplayObject
        {
            // OVERRIDE THIS IN SUBCLASSES
            return null;
        }
        
        protected function updateOrigin():void
        {
            if ( !_viewComponent ) return;
            _viewComponent.pivotX = ( _viewComponent.width / _viewComponent.scaleX ) * _originX;
            _viewComponent.pivotY = ( _viewComponent.height / _viewComponent.scaleY ) * _originY;
        }
    }
}