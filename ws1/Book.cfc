<cfcomponent>
  <cffunction name="listBooks"
    access="remote"
    returntype="string"
    output="no">

    <cfargument name="id" type="numeric"  required="yes"/> 
          
    <cfset Var BookList = "">
    <cfset Var getBooks = "">
    <cfquery name="getBooks" datasource="minisif">
        update FAPreFacturaE
           set foliofacele = 222
          from FAEOrdenImpresion a ,   		 FAPreFacturaE b
			where b.DdocumentoREF = a.OIdocumento
              and oImpresionid = '#id#'
	          and b.CCTcodigoREF = a.CCTcodigo
              and b.TipoDocumentoREF = 1
              and b.Ecodigo = a.Ecodigo
        
        update books
          set price = price + 1
      WHERE Price = '#id#'
        and category = 'INFANTIL'
        
      SELECT ISBN, BookTitle, Teaser, Price
        FROM books
      WHERE category = 'INFANTIL'

    </cfquery>
    <cfreturn getBooks.BookTItle/> 


    <cfsavecontent variable="BookList">
    
      <books> 
        <cfoutput query="getBooks">
          <book id="#ISBN#">
            <booktitle>#XMLFormat(BookTitle)#</booktitle>
            <teaser>#XMLFormat(Teaser)#</teaser>
            <price>#XMLFormat(Price)#</price>
          </book>
        </cfoutput>
      </books>
    </cfsavecontent>

    <cfreturn BookList>
  </cffunction>
</cfcomponent>
