<cf_dbfunction name="OP_concat" returnvariable="_CAT">
<cfparam name="url.OP" default="">
<cfparam name="url.OBEid" default="-1">
<!---=====Abrir Etapa=====--->
<cfif url.OP EQ "A">
	<cfquery datasource="#session.dsn#" name="rsForm_OBetapa">
		update OBetapa
		   set OBEestado = '1'
		 where OBEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.OBEid#">
		   and OBEestado in ('0','2')
	</cfquery>
	
	<script>
		alert('La etapa ha sido Abierta y se han desbloqueado todas sus cuentas financieras activas');
		location.href="OBetapa.cfm?<cfoutput>OBEid=#url.OBEid#</cfoutput>";
	</script>
<!---=====Cerrar Etapa=====--->
<cfelseif url.OP EQ "C">
	<cfquery datasource="#session.dsn#" name="rsForm_OBetapa">
		update OBetapa
		   set OBEestado = '2'
		 where OBEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.OBEid#">
		   and OBEestado in ('1')
	</cfquery>
	
	<script>
		alert('La etapa ha sido Cerrada y se han bloqueado todas sus Cuentas Financieras Activas');
		location.href="OBetapa.cfm?<cfoutput>OBEid=#url.OBEid#</cfoutput>";
	</script>
<cfelseif url.OP EQ "G">
<!---=====Abrir Etapa=====--->
	<cfinvoke component="sif.obras.Componentes.OB_obras" method="fnGeneraCtasObra" OBEid="#url.OBEid#" irA="OBetapa.cfm">
	
<cfelseif url.OP EQ "V">
	<cfquery name="rsSQL" datasource="#session.dsn#">
		update OBetapaCuentas
		   set OBECestado = '1'
			 , OBECmsgGeneracion = null
		 where OBEid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.OBEid#" null="#Len(url.OBEid) Is 0#">
		   and OBECestado = '2'
		   and OBECmsgGeneracion is not null
		   and NOT exists
					(
						select 1
						  from OBproyectoReglas pr
							inner join OBetapa e
							   on e.OBPid = pr.OBPid
							  and e.OBEid = OBetapaCuentas.OBEid
					)
	</cfquery>
	<cfquery name="rsSQL" datasource="#session.dsn#">
		update OBetapaCuentas
		   set OBECestado = '1'
			 , OBECmsgGeneracion = null
		 where OBEid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.OBEid#" null="#Len(url.OBEid) Is 0#">
		   and OBECestado = '2'
		   and OBECmsgGeneracion is not null
		   and exists
					(
						select 1
						  from OBproyectoReglas pr
							inner join OBetapa e
							   on e.OBPid = pr.OBPid
							  and e.OBEid = OBetapaCuentas.OBEid
							  and <cf_dbfunction name="like"args="OBetapaCuentas.CFformato,pr.CFformatoRegla">
							  and coalesce(pr.Ocodigo, e.Ocodigo) = e.Ocodigo
					)
	</cfquery>

	<cfquery name="rsSQL" datasource="#session.dsn#">
		update OBetapaCuentas
		   set OBECestado = '2'
			 , OBECmsgGeneracion = 'La Cuenta Financiera no cumple con las Reglas de Validación definidas para el Proyecto'
		 where OBEid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.OBEid#" null="#Len(url.OBEid) Is 0#">
		   and OBECestado = '1'
		   and exists
					(
						select 1
						  from OBproyectoReglas pr
							inner join OBetapa e
							   on e.OBPid = pr.OBPid
							  and e.OBEid = OBetapaCuentas.OBEid
					)
		   and not exists
					(
						select 1
						  from OBproyectoReglas pr
							inner join OBetapa e
							   on e.OBPid = pr.OBPid
							  and e.OBEid = OBetapaCuentas.OBEid
							  and <cf_dbfunction name="like"args="OBetapaCuentas.CFformato,pr.CFformatoRegla">
							  and coalesce(pr.Ocodigo, e.Ocodigo) = e.Ocodigo
					)
	</cfquery>
	<cflocation url="OBetapa.cfm?OBEid=#url.OBEid#">
<cfelseif IsDefined("url.btnAltaCta")>
	<cfquery datasource="#session.dsn#" name="rsSQL">
		select Ocodigo
		  from OBetapa
		 where OBEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.OBEid#">
	</cfquery>
	<cfset LvarRES = fnAltaCta(url.CFformato, rsSQL.Ocodigo)>
	<cfoutput>
	<script language="javascript">
		<cfif LvarRES.Tipo NEQ "OK">
		alert("#fnJSStringFormat(LvarRES.MSG)#");
		</cfif>
		location.href="OBetapa.cfm?OBEid=#url.OBEid#";
	</script>
	</cfoutput>
<cfelseif IsDefined("url.btnAltaMasivo")>
	<cfset LvarPto = find("-[OG]-",url.CFformato & "-")>
	<cfif LvarPto EQ 0>
		<cf_errorCode	code = "50431" msg = "No se indicó nivel de Objeto de Gasto">
	</cfif>
	<cfset LvarCFformato = "'" & mid(url.CFformato,1,LvarPto) & "' #_CAT# rtrim(dc.PCDvalor)">
	<cfif len(trim(url.CFformato)) GT LvarPto + 5>
		<cfset LvarCFformato = LvarCFformato & " #_CAT# '" & mid(url.CFformato,LvarPto+5,100) & "'">
	</cfif>
	
	<cfquery datasource="#session.dsn#" name="rsSQL">
		select Ocodigo
		  from OBetapa
		 where OBEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.OBEid#">
	</cfquery>
	<cfset LvarOcodigo = rsSQL.Ocodigo>
	
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select #preserveSingleQuotes(LvarCFformato)# as CFformato
		  from OBgrupoOGvalores gog
		  	 inner join PCDCatalogo dc
			   on dc.PCDcatid = gog.PCDcatidOG
		 where gog.OBGid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.OBGid#" null="#Len(url.OBGid) Is 0#">
		   and not exists
		   	(
				select 1
				  from OBetapaCuentas
				 where OBEid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.OBEid#" null="#Len(url.OBEid) Is 0#">
				   and CFformato 	= #preserveSingleQuotes(LvarCFformato)#
			)
		 order by dc.PCDvalor
	</cfquery>
	<CF_templatecss>
	<table>
	<cfoutput query="rsSQL">
		<cfset LvarRES = fnAltaCta(CFformato, LvarOcodigo)>
		<cfif LvarRES.Tipo EQ "E">
		<tr>
			<td style="color:##FF0000;" nowrap>#CFformato#</td>
			<td style="color:##FF0000;">#LvarRES.MSG#</td>
		</tr>
		<cfelseif LvarRES.Tipo EQ "OK no mostrar OK">
		<tr>
			<td nowrap>#CFformato#</td>
			<td>#LvarRES.MSG#</td>
		</tr>
		</cfif>
	</cfoutput>
	</table>
	<cfoutput>
	<script language="javascript">
		alert("Cuentas Agregadas");
		location.href="OBetapa.cfm?OBEid=#url.OBEid#";
	</script>
	</cfoutput>
<cfelseif IsDefined("url.btnActivarCta")>
	<cfquery name="rsSQL" datasource="#session.dsn#">
		update OBetapaCuentas
		   set OBECestado = '1'
		 where OBEid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.OBEid#" null="#Len(url.OBEid) Is 0#">
		   and CFformato 	= <cfqueryparam cfsqltype="cf_sql_char" value="#url.CFformato#" null="#Len(url.CFformato) Is 0#">
		   and OBECestado 	= '2'
		   and OBECmsgGeneracion is null
	</cfquery>
	<cflocation url="OBetapa.cfm?OBEid=#url.OBEid#">
<cfelseif IsDefined("url.btnBajaCta")>
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select OBECestado
		  from OBetapaCuentas
		 where OBEid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.OBEid#" null="#Len(url.OBEid) Is 0#">
		   and CFformato 	= <cfqueryparam cfsqltype="cf_sql_char" value="#url.CFformato#" null="#Len(url.CFformato) Is 0#">
	</cfquery>
	<cfif rsSQL.OBECestado EQ "0">
		<cfquery name="rsSQL" datasource="#session.dsn#">
			delete from OBetapaCuentas
			 where OBEid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.OBEid#" null="#Len(url.OBEid) Is 0#">
			   and CFformato 	= <cfqueryparam cfsqltype="cf_sql_char" value="#url.CFformato#" null="#Len(url.CFformato) Is 0#">
		</cfquery>
	<cfelse>
		<cfquery name="rsSQL" datasource="#session.dsn#">
			update OBetapaCuentas
			   set OBECestado = '2'
			 where OBEid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.OBEid#" null="#Len(url.OBEid) Is 0#">
			   and CFformato 	= <cfqueryparam cfsqltype="cf_sql_char" value="#url.CFformato#" null="#Len(url.CFformato) Is 0#">
		</cfquery>
	</cfif>
	<cflocation url="OBetapa.cfm?OBEid=#url.OBEid#">
<cfelse>
	<cflocation url="OBetapa.cfm?OBEid=#url.OBEid#">
</cfif>

<cffunction name="fnJSStringFormat" returntype="string" output="false">
	<cfargument name="LvarLinea" type="string" required="yes">
	
	<cfset LvarLinea = replace(JSStringFormat(LvarLinea),"\\n","\n","ALL")>
	<cfset LvarLinea = replace(LvarLinea,"&aacute;","á","ALL")>
	<cfset LvarLinea = replace(LvarLinea,"&eacute;","é","ALL")>
	<cfset LvarLinea = replace(LvarLinea,"&iacute;","í","ALL")>
	<cfset LvarLinea = replace(LvarLinea,"&oacute;","ó","ALL")>
	<cfset LvarLinea = replace(LvarLinea,"&uacute;","ú","ALL")>
	
	<cfreturn LvarLinea>
</cffunction>

<cffunction name="fnAltaCta" access="private" output="no" returntype="struct">
	<cfargument name="CFformato" 	required="yes" type="string">
	<cfargument name="Ocodigo" 		required="yes" type="numeric">
	
	<cfset var LvarResultado 		= structNew()>
	
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select OBECestado, CFcuenta
		  from OBetapaCuentas
		 where OBEid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.OBEid#" null="#Len(url.OBEid) Is 0#">
		   and CFformato 	= <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.CFformato#" null="#Len(arguments.CFformato) Is 0#">
	</cfquery>
	<cfif rsSQL.recordCount NEQ 0>
		<cfset LvarResultado.Tipo	= "I">
		<cfset LvarResultado.MSG	= "La Cuenta Financiera ya existe en la Etapa">
		<cfreturn LvarResultado>
	<cfelse>
		<cfinvoke	component="sif.Componentes.PC_GeneraCuentaFinanciera"
					method="fnVerificaCFformato"
					returnvariable="LvarError">
			<cfinvokeargument name="Lprm_Ecodigo"	 			value="#session.Ecodigo#"/>
			<cfinvokeargument name="Lprm_CFformato" 			value="#arguments.CFformato#"/>
			<cfinvokeargument name="Lprm_Ocodigo"	 			value="#arguments.Ocodigo#"/>
			<cfinvokeargument name="Lprm_Fecha" 				value="#now()#"/>

			<cfinvokeargument name="Lprm_VerificarExistencia"	value="false"/>
			<cfinvokeargument name="Lprm_NoVerificarPres"		value="true"/>
			<cfinvokeargument name="Lprm_NoVerificarObras" 		value="yes"/>
		</cfinvoke>
		<cfinvoke	component="sif.Componentes.PC_GeneraCuentaFinanciera"
					method="fnObtieneCFcuenta"
					returnvariable="rsCFinanciera">
			<cfinvokeargument name="Lprm_Ecodigo"	 			value="#session.Ecodigo#"/>
			<cfinvokeargument name="Lprm_CFformato" 			value="#arguments.CFformato#"/>
			<cfinvokeargument name="Lprm_Ocodigo"	 			value="#arguments.Ocodigo#"/>
			<cfinvokeargument name="Lprm_Fecha" 				value="#now()#"/>
		</cfinvoke>
	
		<cfif LvarError NEQ "NEW" AND LvarError NEQ "OLD">
			<cfset LvarResultado.Tipo	= "E">
			<cfset LvarResultado.MSG	= LvarError>
		<cfelse>			
			<cfquery name="rsSQL" datasource="#session.dsn#">
				select CFformatoRegla
				  from OBproyectoReglas
				 where Ecodigo		= #session.Ecodigo#
				   and OBPid		= #session.obras.OBPid#
				   and <cf_dbfunction name="like"args="'#arguments.CFformato#',CFformatoRegla">
			</cfquery>
			<cfif rsSQL.recordCount EQ 0>
				<cfset LvarResultado.Tipo	= "E">
				<cfset LvarResultado.MSG	= "La Cuenta Financiera no cumple con las Reglas de Validación definidas para el Proyecto">
			<cfelse>			
				<cfset LvarResultado.Tipo	= "OK">
				<cfset LvarResultado.MSG	= "OK = La Cuenta Financiera fue incluida en la Etapa">
			</cfif>
		</cfif>
	
		<cfquery datasource="#session.dsn#">
			insert into OBetapaCuentas
				(
					OBEid, CFformato, Ecodigo, OBECestado, CFcuenta, OBECmsgGeneracion
				)
			values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.OBEid#" null="#Len(url.OBEid) Is 0#">
				,	<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.CFformato#" null="#Len(arguments.CFformato) Is 0#">
				,	#session.Ecodigo#
				, '0'
				<cfif LvarResultado.Tipo NEQ "OK">
					, null						
					, <cfqueryparam cfsqltype="cf_sql_char" value="#fnJSStringFormat(replace(LvarResultado.MSG,"'","","ALL"))#" null="#LvarResultado.Tipo EQ "OK"#">
				<cfelseif rsCFinanciera.CFcuenta EQ "">
					, null						
					, null						
				<cfelse>
					, #rsCFinanciera.CFcuenta#
					, null						
				</cfif>
				)
		</cfquery>

		<cfreturn LvarResultado>
	</cfif>
</cffunction>

