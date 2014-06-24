package com.lunarraid.isoproject.model
{
    public static class MapUtil
    {
        public static function getCoordinateHash( x:int, y:int ):int
        {
            return ( ( x < 0 ? ( ( -x & 0x7FFF ) | 0x8000 ) : ( x & 0x7FFF ) ) << 16 ) | ( y < 0 ? ( ( -y & 0x7FFF ) | 0x8000 ) : ( y & 0x7FFF ) ); 
        }
    }
}