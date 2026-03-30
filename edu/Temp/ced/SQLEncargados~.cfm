<cfparam name="action" default="alumno.cfm">

<!--- Por el momento y para la Demo se va a dejar fijo el CEcodigo de la session porque 
se presentaron errores de perdida de la session para cuando se hacia un cambio --->
<cfparam name="Session.CEcodigo" default="13">

<!--- <cfdump var="#form#">
 <cfdump var="#url#">  
<cfdump var="#Session#">--->

<cfif isdefined("form.btnAgregar") or isdefined("form.btnCambiar")>
	<cfset tmp = "" >		<!--- comtenido binario de la imagen --->
	<cfset ts = "null">
	<cfif isdefined("Form.Pfoto") and #form.Pfoto# NEQ "">
		<cftry>
			<!--- Seccion del Upload= Copia la imagen a un folder del servidor servidor --->
			<cffile action="Upload" fileField="form.Pfoto" destination="#GetTempDirectory()#" nameConflict="Overwrite" accept="image/*"> 
			<!--- lee la imagen de la carpeta del servidor y la almacena en la variable tmp --->
			<cffile action="readbinary"  file="#GetTempDirectory()##cffile.ClientFileName#.#cffile.ClientFileExt#" variable="tmp" > 
	
			<cffile action="delete" file="#GetTempDirectory()##cffile.ClientFileName#.#cffile.ClientFileExt#">
		
			<!--- Formato para sybase --->
				<cfset Hex=ListtoArray("0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F")>
		
				<cfif not isArray(tmp)>
					<cfset ts = "">
				</cfif>
				<cfset miarreglo=#ListtoArray(ArraytoList(#tmp#,","),",")#>
				<cfset miarreglo2=ArrayNew(1)>
				<cfset temp=ArraySet(miarreglo2,1,8,"")>
		
				<cfloop index="i" from="1" to=#ArrayLen(miarreglo)#>
					<cfif miarreglo[i] LT 0>
						<cfset miarreglo[i]=miarreglo[i]+256>
					</cfif>
				</cfloop>
		
				<cfloop index="i" from="1" to=#ArrayLen(miarreglo)#>
					<cfif miarreglo[i] LT 10>
						<cfset miarreglo2[i] = "0" & #toString(Hex[(miarreglo[i] MOD 16)+1])#>
					<cfelse>
						<cfset miarreglo2[i] = #trim(toString(Hex[(miarreglo[i] \ 16)+1]))# & #trim(toString(Hex[(miarreglo[i] MOD 16)+1]))#>
					</cfif>
				</cfloop>
				<cfset temp = #ArrayPrepend(miarreglo2,"0x")#>
				<cfset ts = #ArraytoList(miarreglo2,"")#>
			<!--- --->	
			<!--- --------------------------------------------------------------------- --->
		<cfcatch type="any">
<!--- 			<cfinclude template="../../errorPages/BDerror.cfm">
			<cfabort> --->
		</cfcatch>
		</cftry>		
	</cfif>		

	<cftry>
		<cfquery name="ABC_Encargado" datasource="#Session.DSN#">
			<!--- Caso 1: Agregar --->
			<cfif isdefined("Form.btnAgregar")>
				set nocount on
					insert PersonaEducativo 
					(CEcodigo, Pnombre, Papellido1, Papellido2, Ppais, TIcodigo, Pid, Pnacimiento, Psexo, Pemail1, Pemail2, Pdireccion, Pcasa, Pfoto, Pemail1validado)
					values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pnombre#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Papellido1#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Papellido2#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ppais#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TIcodigo#">,							
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pid#">,
							convert( datetime, <cfqueryparam value="#form.Pnacimiento#" cfsqltype="cf_sql_varchar">, 103 ),																				
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Psexo#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pemail1#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pemail2#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pdireccion#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pcasa#">,
							#ts#,0)							

					select @@identity as id
					set nocount off				
				<cfset action = "alumno.cfm">
				<cfset modo="CAMBIO">
				
			<!--- Caso 2: Cambio --->
			<cfelseif isdefined("Form.btnCambiar") and isdefined("form.personaEncar") and #form.personaEncar# NEQ "">
				update PersonaEducativo set
					CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">,
					Pnombre=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pnombre#">,
					Papellido1=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Papellido1#">,
					Papellido2=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Papellido2#">,
					Ppais=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ppais#">,
					TIcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TIcodigo#">,
					Pid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pid#">,
					Pnacimiento=convert( datetime, <cfqueryparam value="#form.Pnacimiento#" cfsqltype="cf_sql_varchar">, 103 ),
					Psexo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Psexo#">,
					Pemail1=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pemail1#">,
					Pemail2=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pemail2#">,
					Pdireccion=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pdireccion#">,
					Pcasa=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pcasa#">,
					<cfif isdefined("Form.Pfoto") and #form.Pfoto# NEQ "">
						Pfoto=#ts#,
					</cfif>					
					Pemail1validado=0
				where persona= <cfqueryparam value="#form.personaEncar#" cfsqltype="cf_sql_numeric">

				<cfset action = "alumno.cfm">								
				<cfset modo="CAMBIO">
			</cfif>					
		</cfquery>
	<cfcatch type="any">
		<cfinclude template="../../errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>		
<cfelseif isdefined("form.btnRegresa")> 
	<cfset action = "alumno.cfm" >
	<cfset modo   = "CAMBIO" >
<cfelseif isdefined("form.btnNuevo")>
	<cfset #form.persona# = "">
	<cfset action = "encargados.cfm" >
	<cfset modo   = "ALTA" >
</cfif>

<cfif isdefined("form.btnAgregar")>
	<cfif isdefined("form.personaEncar") AND #form.personaEncar# EQ "" >
		<cfset #form.personaEncar# = "#ABC_Encargado.id#">
		
		<cftry>
				<cfquery name="ABC_Relaciones" datasource="#Session.DSN#">
					insert Encargado (persona)
					values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.personaEncar#">)					

					insert EncargadoEstudiante (EEcodigo, CEcodigo, Ecodigo)
					values (@@identity,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ecodigo#">)					
				</cfquery>	
			<cfcatch type="any">
				<cfinclude template="../../errorPages/BDerror.cfm">
				<cfabort>
			</cfcatch>
		</cftry>
	</cfif>
</cfif>


<cfoutput>
<form action="#action#" method="post" name="sql">
	<input name="modo"   type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="personaEncar"   type="hidden" value="<cfif isdefined("Form.personaEncar")>#form.personaEncar#</cfif>">
	<input name="persona"   type="hidden" value="<cfif isdefined("Form.persona")>#form.persona#</cfif>">	
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">	
    <input name="Ecodigo" id="Ecodigo" value="<cfoutput>#form.Ecodigo#</cfoutput>" type="hidden">    
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>