package com.lunarraid.isoproject.view.projection
{
	import loom2d.math.Point;
	
    import com.lunarraid.isoproject.math.Point3;
    
    public interface IProjection
    {
        function set tileWidth( value:int ):void;
        function get tileWidth():int;
        function project( position:Point3 ):Point3;
        function unproject( position:Point ):Point3;
    }
}