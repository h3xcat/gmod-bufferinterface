local error = error
local isstring = isstring
local istable = istable
local setmetatable = setmetatable
local type = type
local unpack = unpack
local net_BytesWritten = net.BytesWritten
local net_ReadBool = net.ReadBool
local net_ReadData = net.ReadData
local net_ReadDouble = net.ReadDouble
local net_ReadFloat = net.ReadFloat
local net_ReadInt = net.ReadInt
local net_ReadString = net.ReadString
local net_ReadUInt = net.ReadUInt
local net_ReadVector = net.ReadVector
local net_WriteBool = net.WriteBool
local net_WriteData = net.WriteData
local net_WriteDouble = net.WriteDouble
local net_WriteFloat = net.WriteFloat
local net_WriteInt = net.WriteInt
local net_WriteString = net.WriteString
local net_WriteUInt = net.WriteUInt
local net_WriteVector = net.WriteVector
local string_char = string.char
local string_find = string.find
local string_sub = string.sub
local string_lower = string.lower
--------------------------------------------------------------------------------
BUFFER_INTERFACE_NET = 1
BUFFER_INTERFACE_FILE = 2
BUFFER_INTERFACE_STREAM = 3

local BufferInterface = {}
BufferInterface.__index = BufferInterface

setmetatable(BufferInterface, {
    __call = function(class, ...) return class.new(...) end
})

function BufferInterface.new( obj, offset )
    local self = setmetatable({}, BufferInterface)

    if isstring(obj) and string_lower(obj) == "net" then
        self.buffer_type = BUFFER_INTERFACE_NET
    elseif type(obj) == "File" then
        self.buffer_type = BUFFER_INTERFACE_FILE
        self.buffer_obj = obj
    elseif istable( obj ) and obj.StreamObj then
        self.buffer_type = BUFFER_INTERFACE_STREAM
        self.buffer_obj = obj
    else
        return
    end

    return self
end

--------------------------------------------------------------------------------
-- Double
--------------------------------------------------------------------------------
function BufferInterface:WriteDouble( double )
    if self.buffer_type == BUFFER_INTERFACE_NET then
        net_WriteDouble( double )
    elseif self.buffer_type == BUFFER_INTERFACE_FILE then
        self.buffer_obj:WriteDouble( double )
    elseif self.buffer_type == BUFFER_INTERFACE_STREAM then
        self.buffer_obj:WriteDouble( double )
    end
end

function BufferInterface:ReadDouble()
    if self.buffer_type == BUFFER_INTERFACE_NET then
        return net_ReadDouble()
    elseif self.buffer_type == BUFFER_INTERFACE_FILE then
        return self.buffer_obj:ReadDouble()
    elseif self.buffer_type == BUFFER_INTERFACE_STREAM then
        return self.buffer_obj:ReadDouble()
    end
end
--------------------------------------------------------------------------------
-- Float
--------------------------------------------------------------------------------
function BufferInterface:WriteFloat( float )
    if self.buffer_type == BUFFER_INTERFACE_NET then
        net_WriteFloat( float )
    elseif self.buffer_type == BUFFER_INTERFACE_FILE then
        self.buffer_obj:WriteFloat( float )
    elseif self.buffer_type == BUFFER_INTERFACE_STREAM then
        self.buffer_obj:WriteFloat( float )
    end
end

function BufferInterface:ReadFloat()
    if self.buffer_type == BUFFER_INTERFACE_NET then
        return net_ReadFloat()
    elseif self.buffer_type == BUFFER_INTERFACE_FILE then
        return self.buffer_obj:ReadFloat()
    elseif self.buffer_type == BUFFER_INTERFACE_STREAM then
        return self.buffer_obj:ReadFloat()
    end
end
--------------------------------------------------------------------------------
-- Int32
--------------------------------------------------------------------------------
function BufferInterface:WriteInt32( int32 )
    if self.buffer_type == BUFFER_INTERFACE_NET then
        net_WriteInt( int32, 32 )
    elseif self.buffer_type == BUFFER_INTERFACE_FILE then 
        self.buffer_obj:WriteLong( int32 )
    elseif self.buffer_type == BUFFER_INTERFACE_STREAM then 
        self.buffer_obj:WriteInt32( int32 )
    end
end

function BufferInterface:ReadInt32()
    if self.buffer_type == BUFFER_INTERFACE_NET then
        return net_ReadInt( 32 )
    elseif self.buffer_type == BUFFER_INTERFACE_FILE then
        return self.buffer_obj:ReadLong()
    elseif self.buffer_type == BUFFER_INTERFACE_STREAM then 
        return self.buffer_obj:ReadInt32( )
    end
end
--------------------------------------------------------------------------------
function BufferInterface:WriteUInt32( int32 )
    if self.buffer_type == BUFFER_INTERFACE_NET then
        net_WriteUInt( int32, 32 )
    elseif self.buffer_type == BUFFER_INTERFACE_FILE then
        if int32 >= 0x80000000 then
            int32 = int32 - 0x100000000
        end
        self.buffer_obj:WriteLong( int32 )
    elseif self.buffer_type == BUFFER_INTERFACE_STREAM then 
        self.buffer_obj:WriteUInt32( int32 )
    end
end

function BufferInterface:ReadUInt32()
    if self.buffer_type == BUFFER_INTERFACE_NET then
        return net_ReadUInt( 32 )
    elseif self.buffer_type == BUFFER_INTERFACE_FILE then
        local int32 = self.buffer_obj:ReadLong()
        if int32 < 0 then
            int32 = int32 + 0x100000000
        end
        return int32
    elseif self.buffer_type == BUFFER_INTERFACE_STREAM then 
        return self.buffer_obj:ReadUInt32( )
    end
end
--------------------------------------------------------------------------------
-- Int16
--------------------------------------------------------------------------------
function BufferInterface:WriteInt16( int16 )
    if self.buffer_type == BUFFER_INTERFACE_NET then
        net_WriteInt( int16, 16 )
    elseif self.buffer_type == BUFFER_INTERFACE_FILE then 
        self.buffer_obj:WriteShort( int16 )
    elseif self.buffer_type == BUFFER_INTERFACE_STREAM then 
        self.buffer_obj:WriteInt16( int16 )
    end
end

function BufferInterface:ReadInt16()
    if self.buffer_type == BUFFER_INTERFACE_NET then
        return net_ReadInt( 16 )
    elseif self.buffer_type == BUFFER_INTERFACE_FILE then 
        return self.buffer_obj:ReadShort( )
    elseif self.buffer_type == BUFFER_INTERFACE_STREAM then 
        return self.buffer_obj:ReadInt16( )
    end
end
--------------------------------------------------------------------------------
function BufferInterface:WriteUInt16( int16 )
    if self.buffer_type == BUFFER_INTERFACE_NET then
        net_WriteUInt( int16, 16 )
    elseif self.buffer_type == BUFFER_INTERFACE_FILE then 
        if int16 >= 0x8000 then
            int16 = int16 - 0x10000
        end
        self.buffer_obj:WriteShort( int16 )
    elseif self.buffer_type == BUFFER_INTERFACE_STREAM then 
        self.buffer_obj:WriteUInt16( int16 )
    end
end

function BufferInterface:ReadUInt16()
    if self.buffer_type == BUFFER_INTERFACE_NET then
        return net_ReadUInt( 16 )
    elseif self.buffer_type == BUFFER_INTERFACE_FILE then 
        local int16 = self.buffer_obj:ReadShort()
        if int16 < 0 then
            int16 = int16 + 0x10000
        end
        return int16
    elseif self.buffer_type == BUFFER_INTERFACE_STREAM then 
        return self.buffer_obj:ReadUInt16( )
    end
end
--------------------------------------------------------------------------------
-- Int8
--------------------------------------------------------------------------------
function BufferInterface:WriteInt8( int8 )
    if self.buffer_type == BUFFER_INTERFACE_NET then
        net_WriteInt( int8, 8 )
    elseif self.buffer_type == BUFFER_INTERFACE_FILE then 
        if int8 >= 0x80 then
            int8 = int8 - 0x100
        end
        self.buffer_obj:WriteByte( int8 )
    elseif self.buffer_type == BUFFER_INTERFACE_STREAM then 
        self.buffer_obj:WriteInt8( int8 )
    end
end

function BufferInterface:ReadInt8( )
    if self.buffer_type == BUFFER_INTERFACE_NET then
        return net_ReadInt( 8 )
    elseif self.buffer_type == BUFFER_INTERFACE_FILE then
        local int8 = self.buffer_obj:ReadByte()
        if int8 < 0 then
            int = int8 + 0x100
        end
        return int8
    elseif self.buffer_type == BUFFER_INTERFACE_STREAM then
        return self.buffer_obj:ReadInt8( )
    end
end
--------------------------------------------------------------------------------
function BufferInterface:WriteUInt8( int8 )
    if self.buffer_type == BUFFER_INTERFACE_NET then
        net_WriteUInt( int8, 8 )
    elseif self.buffer_type == BUFFER_INTERFACE_FILE then 
        self.buffer_obj:WriteByte( int8 )
    elseif self.buffer_type == BUFFER_INTERFACE_STREAM then 
        self.buffer_obj:WriteUInt8( int8 )
    end
end

function BufferInterface:ReadUInt8()
    if self.buffer_type == BUFFER_INTERFACE_NET then
        return net_ReadUInt( 8 )
    elseif self.buffer_type == BUFFER_INTERFACE_FILE then
        return self.buffer_obj:ReadByte( )
    elseif self.buffer_type == BUFFER_INTERFACE_STREAM then 
        return self.buffer_obj:ReadUInt8( )
    end
end
--------------------------------------------------------------------------------
-- Bool
--------------------------------------------------------------------------------
function BufferInterface:WriteBool( bool )
    if self.buffer_type == BUFFER_INTERFACE_NET then
        net_WriteBool( bool )
    elseif self.buffer_type == BUFFER_INTERFACE_FILE then
        self.buffer_obj:WriteBool( bool )
    elseif self.buffer_type == BUFFER_INTERFACE_STREAM then
        self.buffer_obj:WriteBool( bool )
    end
end

function BufferInterface:ReadBool()
    if self.buffer_type == BUFFER_INTERFACE_NET then
        return net_ReadBool( )
    elseif self.buffer_type == BUFFER_INTERFACE_FILE then 
        return self.buffer_obj:ReadBool( )
    elseif self.buffer_type == BUFFER_INTERFACE_STREAM then 
        return self.buffer_obj:ReadBool( )
    end
end
--------------------------------------------------------------------------------
-- Vector
--------------------------------------------------------------------------------
function BufferInterface:WriteVector( vector )
    if self.buffer_type == BUFFER_INTERFACE_NET then
        net_WriteVector( vector )
    elseif self.buffer_type == BUFFER_INTERFACE_FILE then 
        self.buffer_obj:WriteFloat( vector.x )
        self.buffer_obj:WriteFloat( vector.y )
        self.buffer_obj:WriteFloat( vector.z )
    elseif self.buffer_type == BUFFER_INTERFACE_STREAM then 
        self.buffer_obj:WriteVector( vector )
    end
end

function BufferInterface:ReadVector()
    if self.buffer_type == BUFFER_INTERFACE_NET then
        return net_ReadVector( )
    elseif self.buffer_type == BUFFER_INTERFACE_FILE then 
        return Vector( self.buffer_obj:ReadFloat( ), self.buffer_obj:ReadFloat( ), self.buffer_obj:ReadFloat( ) )
    elseif self.buffer_type == BUFFER_INTERFACE_STREAM then 
        return self.buffer_obj:ReadVector( )
    end
end
--------------------------------------------------------------------------------
-- String
--------------------------------------------------------------------------------
function BufferInterface:WriteString( str )
    if self.buffer_type == BUFFER_INTERFACE_NET then
        net_WriteString( str )
    elseif self.buffer_type == BUFFER_INTERFACE_FILE then
        local len = string_find( str, "\0" )
        if len then
            self.buffer_obj:Write( string_sub(str, 1, len) )
        else
            self.buffer_obj:Write( str )
            self.buffer_obj:Write( "\0" )
        end
    elseif self.buffer_type == BUFFER_INTERFACE_STREAM then
        self.buffer_obj:WriteString( str )
    end
end

function BufferInterface:ReadString()
    if self.buffer_type == BUFFER_INTERFACE_NET then
        return net_ReadString( )
    elseif self.buffer_type == BUFFER_INTERFACE_FILE then
        local str_t = {}

        local fl = self.buffer_obj
        for i = 1, 7999 do
            local b = fl:ReadByte()
            if b == 0 or b == nil then
                break
            end
            str_t[i] = b
        end

        return string_char( unpack(str_t) )
    elseif self.buffer_type == BUFFER_INTERFACE_STREAM then
        return self.buffer_obj:ReadString()
    end
end
--------------------------------------------------------------------------------
-- Data
--------------------------------------------------------------------------------
function BufferInterface:WriteData( data, len )
    local data_len = #data
    len = len or data_len
    if self.buffer_type == BUFFER_INTERFACE_NET then
        net_WriteData( data, len )
    elseif self.buffer_type == BUFFER_INTERFACE_FILE then
        local fl = self.buffer_obj
        if data_len == len then
            fl:Write( data )
        elseif data_len < len then
            fl:Write( string_sub( data, 1, len ) )
        else
            fl:Write( data )
            fl:Seek(fl:Tell()+(len-data_len))
        end
    elseif self.buffer_type == BUFFER_INTERFACE_STREAM then
        self.buffer_obj:WriteData( data, len )
    end
end

function BufferInterface:ReadData( len )
    if self.buffer_type == BUFFER_INTERFACE_NET then
        return net_ReadData( len )
    elseif self.buffer_type == BUFFER_INTERFACE_FILE then
        return self.buffer_obj:Read( len ) or ""
    elseif self.buffer_type == BUFFER_INTERFACE_STREAM then
        return self.buffer_obj:ReadData( len )
    end
end
--------------------------------------------------------------------------------
function BufferInterface:Seek( pos )
    if self.buffer_type == BUFFER_INTERFACE_NET then
        error( "Seek() is not supported by net library." )
    elseif self.buffer_type == BUFFER_INTERFACE_FILE then
        self.buffer_obj:Seek( pos )
    elseif self.buffer_type == BUFFER_INTERFACE_STREAM then
        self.buffer_obj:Seek( pos )
    end
end

function BufferInterface:Tell( )
    if self.buffer_type == BUFFER_INTERFACE_NET then
        error( "Tell() is not supported by net library." )
    elseif self.buffer_type == BUFFER_INTERFACE_FILE then
        return self.buffer_obj:Tell( )
    elseif self.buffer_type == BUFFER_INTERFACE_STREAM then
        return self.buffer_obj:Tell( )
    end
end

function BufferInterface:Size( )
    if self.buffer_type == BUFFER_INTERFACE_NET then
        return net_BytesWritten( )
    elseif self.buffer_type == BUFFER_INTERFACE_FILE then
        return self.buffer_obj:Size( )
    elseif self.buffer_type == BUFFER_INTERFACE_STREAM then
        return self.buffer_obj:Size( )
    end
end
--------------------------------------------------------------------------------
return BufferInterface