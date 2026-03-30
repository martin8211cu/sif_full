<!---*******************************--->
<!--- definición del arreglo de     --->
<!--- pasos a seguir                --->
<!---*******************************--->
<cfscript>
	Gpaso = 0;
	Gconcurso = 0;
	Gmaxpasoallowed = 0;
	Gdescpasos = ArrayNew(1);
	ArrayAppend(Gdescpasos,'Lista de Concursos');	
 	ArrayAppend(Gdescpasos,'Inclusión de concursantes');	
	ArrayAppend(Gdescpasos,'Resumen');
 	Gmaxpasos = ArrayLen(Gdescpasos)-1;
</cfscript>
<!---ArrayAppend(Gdescpasos,'Valoración de pruebas');--->

<cfif isdefined("url.paso") and len(trim(#url.paso#)) NEQ 0 and not isdefined("form.paso")>
	<cfset form.paso = url.paso>
</cfif>

<cfif isdefined("form.paso") and len(trim(#form.paso#)) NEQ 0>
	<cfset Gpaso = form.paso>
	 <cfset Gmaxpasoallowed = Gpaso-1> 
<cfelse>
	<cfset Gpaso = 0>
</cfif>
	
<cfif isdefined("url.RHCconcurso")>
	<cfset form.RHCconcurso = url.RHCconcurso>
</cfif>	
	
