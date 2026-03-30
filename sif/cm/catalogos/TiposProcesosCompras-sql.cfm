<cfset modo = "ALTA">
<cfif not isdefined("Form.Nuevo")>
<!---=================Agregar un nuevo tipo de proceso======================--->
	<cfif isdefined("Form.Alta")>
		<cfquery name="insert" datasource="#Session.DSN#">
			insert into CMTipoProceso (
				   CMTPCodigo,
				   Ecodigo,
				   CMTPDescripcion,
				   <cfif isdefined('form.CMTPMontoIni')   and form.CMTPMontoIni GT 0.00>CMTPMontoIni,</cfif>
				   <cfif isdefined('form.CMTPMontoFin')   and form.CMTPMontoFin GT 0.00>CMTPMontoFin,</cfif>
				   <cfif isdefined('form.McodigoOri') and Len(rtrim(form.McodigoOri)) GT 0>Mcodigo,</cfif>
					TGidC,
					TGidP,
				   BMUsucodigo,
				   BMFecha)
			values (<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CMTPCodigo#">,
					#Session.Ecodigo#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CMTPDescripcion#">,
				 <cfif isdefined('form.CMTPMontoIni') and form.CMTPMontoIni GT 0.00>
					<cfqueryparam cfsqltype="cf_sql_money" value="#replace(form.CMTPMontoIni,',','','ALL')#">,
				 </cfif>
				 <cfif isdefined('form.CMTPMontoFin') and form.CMTPMontoFin GT 0.00>
					<cfqueryparam cfsqltype="cf_sql_money" value="#replace(form.CMTPMontoFin,',','','ALL')#">,
				 </cfif>
				 <cfif isdefined('form.McodigoOri') and Len(rtrim(form.McodigoOri)) GT 0>
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.McodigoOri#">,
				 </cfif>
				 <cfif isdefined('form.TipoC') and Len(rtrim(form.TipoC)) GT 0>
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TipoC#">,
				<cfelse>
					null,
				 </cfif>
				 <cfif isdefined('form.TipoP') and Len(rtrim(form.TipoP)) GT 0>
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TipoP#">,
				<cfelse>
					null,
				 </cfif>
					#session.Usucodigo#,
					<cf_dbfunction name="now">
				) 
		</cfquery>
		<cfset modo = "ALTA">
<!---====================Eliminar un tipo de proceso=======================--->	
	<cfelseif isdefined("Form.Baja")>
		<!---<cfquery name="deleteAct" datasource="#Session.DSN#">
			delete from CMTPActividades
			  where CMTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMTPid#">
		</cfquery>--->
		
		<cfquery name="rsDatos" datasource="#Session.DSN#">
			select count(1) as cantidad from CMTipoProceso a
			inner join 	CMProcesoCompra b
				on b.CMTPid = a.CMTPid
			  where a.Ecodigo  = #Session.Ecodigo#
			and a.CMTPCodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CMTPCodigo#">
		</cfquery>
		
		<cfif rsDatos.cantidad gt 0>	
			<cfthrow message="No se puede eliminar el registro ya que tiene ordenes de compra ligadas.">
		<cfelse>		
			<cfquery name="delete" datasource="#Session.DSN#">
				delete from CMTipoProceso
				  where Ecodigo  = #Session.Ecodigo#
				and CMTPCodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CMTPCodigo#">
			</cfquery>
		</cfif>
		
		<cfset modo="ALTA">
<!---====================Modificar un tipo de proceso=======================--->
	<cfelseif isdefined("Form.Cambio")>
	    <cf_dbtimestamp
					datasource="#session.dsn#"
					table="CMTipoProceso" 
					redirect="TiposProcesosCompras.cfm"
					timestamp="#form.ts_rversion#"
					field1="Ecodigo,integer,#session.Ecodigo#"
					field2="CMTPCodigo,varchar,#form.CMTPCodigo#">
					
		<cfquery name="update" datasource="#Session.DSN#">
			update CMTipoProceso set 
				   	CMTPDescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CMTPDescripcion#">
			    <cfif isdefined('form.CMTPMontoIni') and form.CMTPMontoIni GT 0.00>
				  	,CMTPMontoIni = <cfqueryparam cfsqltype="cf_sql_numeric" scale="2" value="#replace(form.CMTPMontoIni,',','','ALL')#">					                
				</cfif>
				<cfif isdefined('form.CMTPMontoFin') and form.CMTPMontoFin GT 0.00>
					,CMTPMontoFin = <cfqueryparam cfsqltype="cf_sql_numeric" scale="2" value="#replace(form.CMTPMontoFin,',','','ALL')#">
				</cfif>
				<cfif isdefined('form.McodigoOri') and Len(rtrim(form.McodigoOri)) GT 0>   
					,Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.McodigoOri#">
				</cfif>
				,TGidC  = <cfif isdefined("form.TipoC") and Len(Trim(form.TipoC)) and form.TipoC NEQ -1> <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TipoC#"> <cfelse> null </cfif>
				,TGidP  = <cfif isdefined("form.TipoP") and Len(Trim(form.TipoP)) and form.TipoP NEQ -1> <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TipoP#"> <cfelse> null </cfif>
			where Ecodigo       = #Session.Ecodigo#
			  and CMTPCodigo    = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CMTPCodigo#">
		</cfquery> 
		<cfset modo="CAMBIO">
		
	</cfif>
</cfif>

<form action="TiposProcesosCompras.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<input name="CMTPCodigo" type="hidden" value="<cfif isdefined("form.CMTPCodigo") and modo neq 'ALTA'><cfoutput>#form.CMTPCodigo#</cfoutput></cfif>">
</form>
	
<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>

