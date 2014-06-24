package com.lunarraid.isoproject.view
{
    import loom2d.display.DisplayObject;
    import loom2d.display.Sprite;
    import loom2d.events.EnterFrameEvent;
    
    import loom2d.math.Point;

    import com.lunarraid.isoproject.math.Point3;
    
    import com.lunarraid.isoproject.view.projection.IProjection;
    import com.lunarraid.isoproject.view.projection.IsoProjection;
    
    public class ProjectedViewManager
    {
        //--------------------------------------
        // PRIVATE / PROTECTED
        //--------------------------------------
        
        private var _viewComponent:Sprite;
        private var _children:Vector.<ProjectedViewRenderer>;
        private var _projection:IProjection;
        private var _depthSort:Boolean = true;
        
        //--------------------------------------
        //  CONSTRUCTOR
        //--------------------------------------
        
        public function ProjectedViewManager( projection:IProjection )
        {
            _projection = projection;
            _viewComponent = new Sprite();
            _viewComponent.depthSort = _depthSort;
            _children = [];
        }
        
        //--------------------------------------
        //  GETTERS / SETTERS
        //--------------------------------------
        
        public function get viewComponent():DisplayObject { return _viewComponent; }
        
        public function get projection():IProjection { return _projection; }
        public function set projection( value:IProjection ):void { _projection = value; }
        
        public function get tileWidth():int { return _projection.tileWidth; }
        
        public function set tileWidth( value:int ):void
        {
            _projection.tileWidth = value;
            updateChildPositions();
        }
        
        public function get depthSort():Boolean { return _depthSort; }
        
        public function set depthSort( value:Boolean ):void
        {
            _depthSort = value;
            if ( _viewComponent ) _viewComponent.depthSort = value;
        }
        
        public function get numChildren():int
        {
            return _children.length;
        }
        
        //--------------------------------------
        //  PUBLIC METHODS
        //--------------------------------------
        
        public function destroy():void
        {
            removeChildren( true );
            _viewComponent.dispose();
            _viewComponent = null;
        }
        
        public function addChild( child:ProjectedViewRenderer ):void
        {
            if ( _children.indexOf( child ) == -1 )
            {
                _children.push( child );
                _viewComponent.addChild( child.viewComponent );
                child.viewManager = this;
            }
        }
        
        public function removeChild( child:ProjectedViewRenderer ):void
        {
            var childIndex:int = _children.indexOf( child );
            if ( childIndex > -1 ) _children.remove( child );
            {
                _children.remove( child );
                _viewComponent.removeChild( child.viewComponent );
            }
        }
        
        public function removeChildren( dispose:Boolean = false ):void
        {
            while ( _children.length > 0 ) _children.pop().viewManager = null;
            _viewComponent.removeChildren( 0, -1, dispose );
        }
        
        public function getChildByName( name:String ):ProjectedViewRenderer
        {
            var childCount:int = numChildren;
            for ( var i:int = 0; i < childCount; i++ ) if ( _children[ i ].name == name ) return _children[ i ];
            return null;
        }
        
        public function project( position:Point3 ):Point3 { return _projection.project( position ); }
        public function unproject( position:Point ):Point3 { return _projection.unproject( position ); }
        
        //--------------------------------------
        //  PRIVATE / PROTECTED METHODS
        //--------------------------------------
        
        private function updateChildPositions():void
        {
            var numChildren:int = _children.length;
            for ( var i:int = 0; i < numChildren; i++ ) _children[ i ].updatePosition();
        }
    }
}