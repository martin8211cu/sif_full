<cfset LvarA = 10>
<cfset LvarB = 8>

<cfquery datasource="minisif" name="rs">
select #LvarA# - #LvarB# from dual
</cfquery>

<cfdump var="#rs#">

<!--- <cfreport report="" 
 datasource = "minisif" 
 username = "store12345" 
 password = "#form.userPassword#" 
 @reporttitle = "'Customer Price List'" 
 orderby = "products.price"> 

 {products.description} = '#form.selectedProduct#' AND 
 {products.location} LIKE 'Warehouse*' 

 <cfif #form.priceRangeStart# IS NOT 0> 
	 AND {products.price} BETWEEN #form.priceRangeStart# AND #form.priceRangeEnd# 
 <cfelse> 
	 AND {products.price} #form.priceRangeEnd# 
 </cfif> 
</cfreport> --->