package
{
    import loom.Application;
	import loom2d.display.DisplayObject;
    import com.lunarraid.isoproject.group.TiledMapGroup;

    public class IsoProject extends Application
    {
        override public function run():void
        {
            // Create our TiledMapGroup, which handles rendering and spawning
            var tiledMapGroup:TiledMapGroup = new TiledMapGroup();
            tiledMapGroup.owningGroup = group;
            tiledMapGroup.initialize( "TiledMapGroup" );
            
            // Add our view to the stage and center it
            var mapView:DisplayObject = tiledMapGroup.viewComponent;
            mapView.scale = 0.5;
            mapView.x = stage.stageWidth * 0.5;
            mapView.y = ( stage.stageHeight - mapView.height ) * 0.5;
            stage.addChild( mapView );
        }
    }
}