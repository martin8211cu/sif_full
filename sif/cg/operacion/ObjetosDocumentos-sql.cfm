<cfparam name="sufix" default="">

<cfset modo = "ALTA">
<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>		
		<cfif isdefined("form.tipo") and form.tipo NEQ '1'> 
			<cfset extension1 = listtoarray(form.nArchivo,'.')>
			<cfset extension = extension1[arraylen(extension1)]>
		</cfif>	
		
		 <!--- Campo ECStipo	0: Texto digitable, 1:Imagen, 2:Archivo----->
		 <!--- Valores del option buton rdTipo	't':texto digitable, 'i':imagen, 'o':Archivo (i & o trabajan de la misma forma, es decir guardan un archivo seleccionado por el usuario)---->
		<cfquery name="insert" datasource="#session.DSN#">
			insert into EContableSoporte (IDcontable, ECStipo, ECScontenttype, ECStexto, ECScontenido, ECSdescripcion, BMfalta, BMUsucodigo)
			values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDcontable#">,
					<cfif isdefined("form.rdTipo") and form.rdTipo EQ 't'>0
					<cfelseif isdefined("form.rdTipo") and form.rdTipo EQ 'i'>1
					<cfelse>2
					</cfif>,
					<cfif isdefined("form.rdTipo") and form.rdTipo NEQ 't'>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#extension#">
					<cfelse>
						'txt'	
					</cfif>,
					<cfif (isdefined("form.rdTipo") and form.rdTipo EQ 't') and (isdefined("form.txaECStexto"))>
						<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.txaECStexto#">
					<cfelse>
						null
					</cfif>,
					<cfif isdefined("form.rdTipo") and form.rdTipo NEQ 't'>
						<cfif isdefined("Form.ECScontenido") and len(trim(Form.ECScontenido))><cf_dbupload filefield="ECScontenido" accept="*/*" datasource="#session.DSN#"><cfelse>null</cfif> 
					<cfelse>	
						null
					</cfif>,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ECSdescripcion#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				)
		</cfquery>
		
		<cfset modo = "ALTA">	
	
	<cfelseif isdefined("Form.Baja")>
		<cfquery name="delete" datasource="#session.DSN#">
			delete from EContableSoporte
			where IDdocsoporte = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDdocsoporte#">
				and IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDcontable#">
		</cfquery>
		<cfset modo = "ALTA">	
	
	<cfelseif isdefined("Form.Cambio")>
		
		<cf_dbtimestamp datasource="#session.DSN#"
			 			table="EContableSoporte"
			 			redirect="ObjetosDocumentos#sufix#.cfm"
			 			timestamp="#form.ts_rversion#"				
						field1="IDdocsoporte" 
						type1="numeric" 
						value1="#form.IDdocsoporte#"
						field2="IDcontable" 
						type2="numeric" 
						value2="#form.IDcontable#"
						>
	 	
		<cfset extension1 = listtoarray(form.nArchivo,'.')>
		<cfif (arraylen(extension1)) NEQ 0>
			<cfset extension = extension1[arraylen(extension1)]>
			<cfquery name="UpdateExtension" datasource="#session.DSN#">
				update EContableSoporte set					
					ECScontenttype = <cfif isdefined("form.rdTipo") and form.rdTipo NEQ 't'>
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#extension#">
									<cfelse>
										null	
									</cfif>
				where IDdocsoporte = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDdocsoporte#">
					and IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDcontable#">					
			</cfquery>
		</cfif>
		
		<cfquery name="update" datasource="#session.DSN#">
			update 	EContableSoporte set
					ECSdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ECSdescripcion#">,
					ECStexto = 	<cfif (isdefined("form.tipo") and form.tipo EQ 1) and (isdefined("form.txaECStexto"))>
									<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.txaECStexto#">
								<cfelse>
									null
								</cfif>,
					ECScontenido = <cfif isdefined("form.tipo") and form.tipo NEQ 1>
										<cfif isdefined("Form.ECScontenido") and len(trim(Form.ECScontenido))><cf_dbupload filefield="ECScontenido" accept="*/*" datasource="#session.DSN#"><cfelse>null</cfif> 
									<cfelse>	
										null
									</cfif>
			where IDdocsoporte = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDdocsoporte#">
				and IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDcontable#">					
		</cfquery> 

		<cfset modo="CAMBIO">
	</cfif>
</cfif>

<cfoutput>
<form action="ObjetosDocumentos#sufix#.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="IDdocsoporte" type="hidden" value="<cfif isdefined("Form.IDdocsoporte") and modo NEQ 'ALTA'>#Form.IDdocsoporte#</cfif>">
	<input name="IDcontable" type="hidden" value="<cfif isdefined("Form.IDcontable")>#Form.IDcontable#</cfif>">
	<input type="hidden" name="Pagina" value="<cfif isdefined("Pagenum_lista") and Pagenum_lista NEQ "">#Pagenum_lista#<cfelseif isdefined("Form.PageNum")><cfoutput>#PageNum#</cfoutput></cfif>">		
</form>
</cfoutput>	

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
