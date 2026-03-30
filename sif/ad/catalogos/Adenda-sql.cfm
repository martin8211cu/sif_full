
<!---impresión de la forma--->
<cfparam name="form" default="">

<!---Ecodigo--->
<!---<br/>
<cfdump var= #Session.Ecodigo# />
<br/>
<cfdump var= #getMetadata(Session.Ecodigo).getName()# />--->

<!---SNcodigo--->
<!---<br/>
<cfdump var= #form.SNcodigo# />
<br/>
<cfdump var= #getMetadata(form.SNcodigo).getName()# />
<br/>
--->
<!---ADDcodigo--->

<cfparam 	name="form.AddendaPorImprimir"
    		type="string"
    		default="">

<cfparam
    name="listaADDcodigos"
    type="array"
    default= "#ListToArray(form.AddendaPorImprimir)#"
    />



<!---AdendasAsignadasAlSocio--->

<cfquery name="AdendasAsignadasAlSocio" datasource="#Session.DSN#">
	select ADDcodigo, StatusSeleccion
	from SocioAddenda
	where SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
</cfquery>

<!---Cambia todos los status de selección a cero--->
<cfquery name="ActualizaParaNoImprimir" datasource="#Session.DSN#">
	UPDATE SocioAddenda SET StatusSeleccion = 0 WHERE SNcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SNcodigo#">
</cfquery>


<!---Aquí se va a armar el loop en el --->
<cfloop array=#listaADDcodigos# index="nameAddenda">
    <cfoutput>#nameAddenda#</cfoutput><br>

	<cfquery name="BuscaAddendaEnSocio" datasource="#Session.DSN#">
		select Ecodigo
		from SocioAddenda
		where SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNcodigo#"> 
		and   ADDcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#nameAddenda#">
	</cfquery>

	<!---si el ecodigo es mayor que cero quiere decir que el socio existe y tiene asignada tal addcodigo, entonces cambia su statusseleccion a 1--->
	<!---Si no es mayor que cero, entonces el socio no tiene asignada dicha adenda y agrega la linea en la base de datos --->
	<cfif BuscaAddendaEnSocio.Ecodigo gt 0>	
		<cfquery name="ActualizaParaNoImprimir" datasource="#Session.DSN#">
			UPDATE SocioAddenda 
			SET StatusSeleccion = 1 
			where SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#"> 
			and   ADDcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#nameAddenda#">
		</cfquery>
	<cfelse>
		<cfquery name="InsertaNuevaAddenda" datasource="#session.dsn#" >
			insert into SocioAddenda(Ecodigo, SNcodigo, ADDcodigo,BMUsucodigo,StatusSeleccion) 
								values(<cfqueryparam cfsqltype="cf_sql_integer"		value="#Session.Ecodigo#" >,
									   <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.SNcodigo#">,
									   <cfqueryparam cfsqltype="cf_sql_char" 		value="#nameAddenda#">,
									   <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Session.usucodigo#">,
									   <cfqueryparam cfsqltype="cf_sql_numeric" 	value="1">
									   )						
		</cfquery>
	</cfif>
</cfloop>

<cflocation url="Socios.cfm?SNcodigo=#form.SNcodigo#&tab=8">

