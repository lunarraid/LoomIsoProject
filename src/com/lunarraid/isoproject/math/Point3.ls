package com.lunarraid.isoproject.math
{
    import system.String;
    
    public struct Point3 
    {
        public var x:Number;
        public var y:Number;
        public var z:Number;

        private static var _scratchPoint:Point3;
        
        public function Point3( x:Number = 0, y:Number = 0, z:Number = 0 )
        {
            setTo( x, y, z );
        }

        public function setTo( x:Number, y:Number, z:Number ):void
        {
            this.x = x;
            this.y = y;
            this.z = z;
        }
        
        public function dotProduct( source:Point3 ):Number
        {
            return ( x * source.x ) + ( y * source.y ) + ( z * source.z );
        }
        
        public function scaleBy( value:Number ):void
        {
            x *= value;
            y *= value;
            z *= value;
        }
        
        public static operator function +( p1:Point3, p2:Point3 ):Point3
        {
            _scratchPoint.x = p1.x + p2.x;
            _scratchPoint.y = p1.y + p2.y;
            _scratchPoint.z = p1.z + p2.z;
            return _scratchPoint;
        }    

        public operator function +=( p:Point3 ):void
        {
            x += p.x;
            y += p.y;
            z += p.z;
        }

        public static operator function -( p1:Point3, p2:Point3 ):Point3
        {
            _scratchPoint.x = p1.x - p2.x;
            _scratchPoint.y = p1.y - p2.y;
            _scratchPoint.z = p1.z - p2.z;
            return _scratchPoint;
        }    

        public operator function -=( p:Point3 ):void
        {
            x -= p.x;
            y -= p.y;
            z -= p.z;
        }
        
        public static operator function =( p1:Point3, p2:Point3 ):Point3
        {
            p1.x = p2.x;
            p1.y = p2.y;
            p1.z = p2.z;
            return p1;
        }        
            
        public function toString():String
        {
            return "{ x: " + x + ", y: " + y + ", z: " + z + " }"; 
        }
    }   
}