<!---
<cfquery datasource="#cfartist#" name ="vertabla">
select * from ART
</cfquery>
<cfdump var="#vertabla#">
--->
<cfparam  name="form.tcadena" default="no tenia nada">
<cfparam  name="form.hcadena" default="no tenia nada hcadena">
<cfset lista = "naranja, banano, kewi, melocoton">



<form method="post" action="prueba1.cfm">
<input type="text" name="tcadena" >            <!--- "<cfif modo neq 'ALTA'>#data.WECdescripcion#</cfif>" onfocus="this.select();" --->
<!---<input type = "hidden" name = "hcadena" value = "#form.tcadena#">--->
<input type = "hidden" name = "hcadena" value = "<cfif isdefined("form.tcadena")><cfoutput>#form.tcadena#</cfoutput></cfif>"onfocus="this.select();">
<input type="submit" name ="btncadena"  value="Consultar" >
</form>

<cfset tcadena = "#form.tcadena#">
<cfset hcadena1 = "#form.hcadena#">
<cfif isdefined("form.btncadena")>
<cfoutput>



El texto digitado fue: #tcadena# <br>
El valor de hcadena es: #hcadena1# <br>
La fecha de hoy es: #lsdateformat(now(),"dddd, dd mmmm, yyyy")# <br>

El valor de la lista es: #listlen(lista)#<br>
Lista y elementos al revés: #reverse(lista)#<br>
Lista en mayúscula: #ucase(lista)#<br>




</cfoutput>
</cfif>





