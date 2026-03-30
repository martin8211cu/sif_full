
<cfset corte = "#url.corte#">
<cfset  sync = createObject("component", "home.public.sincronizaWeb.syncWeb").init("minisif", 2)>

<cfset sync.sincroniza(corte)>
<cfdump  var="DONE!!!!">