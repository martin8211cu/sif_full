<cfcomponent>
  <cffunction name="listBooks"
    access="remote"
    returntype="string"
    output="no">

    <cfargument name="precio" type="numeric"  required="yes"/> 
    <cfargument name="categoria" type="string"  required="yes"/> 
          
    <cfset Var BookList = "">
    <cfset Var getBooks = "">
    <cfquery name="getBooks" datasource="minisif">
        update FAPreFacturaE
           set foliofacele = 222,
               FACTURA = 'TRUE'
         where idprefactura = 562
        
        update books
          set price = price + 1
      WHERE Price = '#precio#'
        and category = '#categoria#'
        
      SELECT ISBN, BookTitle, Teaser, Price
        FROM books
      WHERE category = '#categoria#'

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
