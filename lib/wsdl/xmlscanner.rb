=begin
SOAP4R - WSDL XMLScan parser library.
Copyright (C) 2002 NAKAMURA Hiroshi.

This program is free software; you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation; either version 2 of the License, or (at your option) any later
version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PRATICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
this program; if not, write to the Free Software Foundation, Inc., 675 Mass
Ave, Cambridge, MA 02139, USA.
=end

require 'wsdl/parser'
require 'xmlscan/scanner'


module WSDL


class WSDLXMLScanner < WSDLParser
  def initialize( *vars )
    super( *vars )
  end

  def doParse( stringOrReadable )
    Scanner.new( self ).parse( stringOrReadable )
  end

  class Scanner < XMLScan::XMLScanner
    def initialize( dest )
      super()
      @dest = dest
    end

    def on_stag( name, attr )
      @dest.startElement( name, attr )
    end
  
    def on_etag( name )
      @dest.endElement( name )
    end

    def on_chardata( str )
      @dest.characters( str )
    end

    ENTITY_REF_MAP = {
      'lt' => '<',
      'gt' => '>',
      'amp' => '&',
      'quot' => '"',
      'apos' => '\'' }
    def on_entityref( ref )
      @dest.characters( ENTITY_REF_MAP[ ref ] )
    end

    def on_charref( code )
      @dest.characters( [ Integer( code ) ].pack( "U*" ))
    end

    def on_xmldecl( decls )
      # ?
    end
  end

  setFactory( self )
end


end
