<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ElOferenteExternoYaExisteVerifique"
	Default="El Oferente Externo ya existe. Verifique."
	returnvariable="LB_ElOferenteExternoYaExisteVerifique"/>

<cfset modo="ALTA">
<!--- Carga de la imagen del Oferente --->
<cfset tmp = "" >		<!--- contenido binario de la imagen --->
<cfset ts = "null">


	<cfif not isdefined("Form.Nuevo")>
		<cfset action = "/cfmx/rh/Reclutamiento/catalogos/OferenteExterno.cfm">
		
		<cfif isdefined("Form.Alta")>
			<cfquery name="rsExisteOferente" datasource="#Session.DSN#">
				select 1
				from DatosOferentes a
				where a.NTIcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.NTIcodigo#">
				  and a.RHOidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHOidentificacion#">
				  and a.Ecodigo 		  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			</cfquery>
			<cfif rsExisteOferente.recordCount GT 0>
				<cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=0&errMsg=#LB_ElOferenteExternoYaExisteVerifique#" 
					addtoken="no">
				<cfabort> 
			</cfif>
		</cfif>
		<cfif isdefined("Form.Alta")>
			<cf_direccion action="readform" name="direccion">
			<cf_direccion action="insert" data="#direccion#" name="direccion">
			<cftransaction>
			
				<cfquery name="ABC_datosOferente" datasource="#Session.DSN#">
					insert into DatosOferentes 
					(Ecodigo, NTIcodigo, RHOidentificacion, 
						RHOnombre, RHOapellido1, RHOapellido2, 
						<!--- RHOdireccion, --->
						id_direccion,
						RHOtelefono1,RHOtelefono2,RHOemail,
						RHOcivil, RHOfechanac, RHOsexo,
						RHOobs1, RHOobs2, RHOobs3, 
						RHOdato1, RHOdato2, RHOdato3, RHOdato4, RHOdato5, 
						RHOinfo1, RHOinfo2, RHOinfo3,Ppais,BMUsucodigo,
						RHOfechaRecep,
						RHOfechaIngr,
						RHOPrenteInf,
						RHOPrenteSup,
						RHOPosViajar,
						RHOPosTralado,
						RHOLengOral1,
						RHOLengOral2,
						RHOLengOral3,
						RHOLengEscr1,
						RHOLengEscr2,
						RHOLengEscr3,
						RHOLengLect1,
						RHOLengLect2,
						RHOLengLect3,
						RHORefValida,
						RHOIdioma1,
						RHOIdioma2,
						RHOIdioma3,
						RHOEntrevistado,
						RHOfechaEntrevista,
						RHORealizadaPor,
						RHOMonedaPrt,
						RHOLengOral4, RHOLengEscr4, RHOIdioma4, RHOLengLect4,
						RHOLengOral5, RHOLengEscr5, RHOOtroIdioma5, RHOLengLect5
					)
					values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.NTIcodigo#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHOidentificacion#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHOnombre#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHOapellido1#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHOapellido2#">,
						<!--- <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHOdireccion#">, --->
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#direccion.id_direccion#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHOtelefono1#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHOtelefono2#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHOemail#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHOcivil#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_date" 	value="#LsParseDateTime(Form.RHOfechanac)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHOsexo#">,
						<cfif isdefined('form.RHOobs1')>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHOobs1#" null="#Len(Trim(Form.RHOobs1)) EQ 0#">,
						<cfelse>
							null,
						</cfif>
						<cfif isdefined('form.RHOobs2')>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHOobs2#" null="#Len(Trim(Form.RHOobs2)) EQ 0#">,
						<cfelse>
							null,
						</cfif>
						<cfif isdefined('form.RHOobs3')>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHOobs3#" null="#Len(Trim(Form.RHOobs3)) EQ 0#">,
						<cfelse>
							null,
						</cfif>
						<cfif isdefined('form.RHOdato1')>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHOdato1#" null="#Len(Trim(Form.RHOdato1)) EQ 0#">,
						<cfelse>
							null,
						</cfif>
						<cfif isdefined('form.RHOdato2')>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHOdato2#" null="#Len(Trim(Form.RHOdato2)) EQ 0#">,
						<cfelse>
							null,
						</cfif>
						<cfif isdefined('form.RHOdato3')>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHOdato3#" null="#Len(Trim(Form.RHOdato3)) EQ 0#">,
						<cfelse>
							null,
						</cfif>
						<cfif isdefined('form.RHOdato4')>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHOdato4#" null="#Len(Trim(Form.RHOdato4)) EQ 0#">,
						<cfelse>
							null,
						</cfif>
						<cfif isdefined('form.RHOdato5')>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHOdato5#" null="#Len(Trim(Form.RHOdato5)) EQ 0#">,
						<cfelse>
							null,
						</cfif>
						<cfif isdefined('form.RHOinfo1')>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHOinfo1#" null="#Len(Trim(Form.RHOinfo1)) EQ 0#">,
						<cfelse>
							null,
						</cfif>
						<cfif isdefined('form.RHOinfo2')>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHOinfo2#" null="#Len(Trim(Form.RHOinfo2)) EQ 0#">,
						<cfelse>
							null,
						</cfif>
						<cfif isdefined('form.RHOinfo3')>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHOinfo3#" null="#Len(Trim(Form.RHOinfo3)) EQ 0#">,
						<cfelse>
							null,
						</cfif>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ppais#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
						,<cfif isdefined("form.RHOfechaRecep") and len(trim(form.RHOfechaRecep))>
                        	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParsedateTime(form.RHOfechaRecep)#"><cfelse>null</cfif>
						,<cfif isdefined("form.RHOfechaIngr") and len(trim(form.RHOfechaIngr))><cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParsedateTime(form.RHOfechaIngr)#"><cfelse>null</cfif>
						,<cfif isdefined("form.RHOPrenteInf") and len(trim(form.RHOPrenteInf))><cfqueryparam cfsqltype="cf_sql_float" value="#replace(form.RHOPrenteInf, ',','','all')#"><cfelse>null</cfif>
						,<cfif isdefined("form.RHOPrenteSup") and len(trim(form.RHOPrenteSup))><cfqueryparam cfsqltype="cf_sql_float" value="#replace(form.RHOPrenteSup, ',','','all')#"><cfelse>null</cfif>
						<cfif isDefined("Form.RHOPosViajar")>
						  ,<cfqueryparam cfsqltype="cf_sql_integer" value="1">
						<cfelse>
						  ,<cfqueryparam cfsqltype="cf_sql_integer" value="0">
						</cfif>	
						<cfif isDefined("Form.RHOPosTralado")>
						  ,<cfqueryparam cfsqltype="cf_sql_integer" value="1">
						<cfelse>
						  ,<cfqueryparam cfsqltype="cf_sql_integer" value="0">
						</cfif>						
						, <cfif isdefined("form.RHOLengOral1") and len(trim(form.RHOLengOral1))><cfqueryparam cfsqltype="cf_sql_float" value="#form.RHOLengOral1#"><cfelse>null</cfif>
						, <cfif isdefined("form.RHOLengOral2") and len(trim(form.RHOLengOral2))><cfqueryparam cfsqltype="cf_sql_float" value="#form.RHOLengOral2#"><cfelse>null</cfif>
						, <cfif isdefined("form.RHOLengOral3") and len(trim(form.RHOLengOral3))><cfqueryparam cfsqltype="cf_sql_float" value="#form.RHOLengOral3#"><cfelse>null</cfif>
						, <cfif isdefined("form.RHOLengEscr1") and len(trim(form.RHOLengEscr1))><cfqueryparam cfsqltype="cf_sql_float" value="#form.RHOLengEscr1#"><cfelse>null</cfif>
						, <cfif isdefined("form.RHOLengEscr2") and len(trim(form.RHOLengEscr2))><cfqueryparam cfsqltype="cf_sql_float" value="#form.RHOLengEscr2#"><cfelse>null</cfif>
						, <cfif isdefined("form.RHOLengEscr3") and len(trim(form.RHOLengEscr3))><cfqueryparam cfsqltype="cf_sql_float" value="#form.RHOLengEscr3#"><cfelse>null</cfif>
						, <cfif isdefined("form.RHOLengLect1") and len(trim(form.RHOLengLect1))><cfqueryparam cfsqltype="cf_sql_float" value="#form.RHOLengLect1#"><cfelse>null</cfif>
						, <cfif isdefined("form.RHOLengLect2") and len(trim(form.RHOLengLect2))><cfqueryparam cfsqltype="cf_sql_float" value="#form.RHOLengLect2#"><cfelse>null</cfif>
						, <cfif isdefined("form.RHOLengLect3") and len(trim(form.RHOLengLect3))><cfqueryparam cfsqltype="cf_sql_float" value="#form.RHOLengLect3#"><cfelse>null</cfif>
						<cfif isDefined("Form.RHORefValida")>
						  ,<cfqueryparam cfsqltype="cf_sql_integer" value="1">
						<cfelse>
						  ,<cfqueryparam cfsqltype="cf_sql_integer" value="0">
						</cfif>	
						, <cfif isdefined("form.RHOIdioma1") and len(trim(form.RHOIdioma1))><cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHOIdioma1#"><cfelse>null</cfif>
						, <cfif isdefined("form.RHOIdioma2") and len(trim(form.RHOIdioma2))><cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHOIdioma2#"><cfelse>null</cfif>
						, <cfif isdefined("form.RHOIdioma3") and len(trim(form.RHOIdioma3))><cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHOIdioma3#"><cfelse>null</cfif>
						
						<cfif isDefined("Form.RHOEntrevistado")>
							,<cfqueryparam cfsqltype="cf_sql_integer" value="1">
							,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParsedateTime(form.RHOfechaEntrevista)#">
							,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHORealizadaPor#">
						<cfelse>
							,<cfqueryparam cfsqltype="cf_sql_integer" value="0">
							,null
							,null
						</cfif>
						, <cfif isdefined("form.RHOMonedaPrt") and len(trim(form.RHOMonedaPrt))><cfqueryparam cfsqltype="cf_sql_char"    value="#form.RHOMonedaPrt#">	<cfelse>null</cfif>		

						, <cfif isdefined("form.RHOLengOral4") and len(trim(form.RHOLengOral4))><cfqueryparam cfsqltype="cf_sql_float" value="#form.RHOLengOral4#"><cfelse>null</cfif>	
						, <cfif isdefined("form.RHOLengEscr4") and len(trim(form.RHOLengEscr4))><cfqueryparam cfsqltype="cf_sql_float" value="#form.RHOLengEscr4#"><cfelse>null</cfif> 
						, <cfif isdefined("form.RHOIdioma4") and len(trim(form.RHOIdioma4))><cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHOIdioma4#"><cfelse>null</cfif>
						, <cfif isdefined("form.RHOLengLect4") and len(trim(form.RHOLengLect4))><cfqueryparam cfsqltype="cf_sql_float" value="#form.RHOLengLect4#"><cfelse>null</cfif>
						, <cfif isdefined("form.RHOLengOral5") and len(trim(form.RHOLengOral5))><cfqueryparam cfsqltype="cf_sql_float" value="#form.RHOLengOral5#"><cfelse>null</cfif>	
						, <cfif isdefined("form.RHOLengEscr5") and len(trim(form.RHOLengEscr5))><cfqueryparam cfsqltype="cf_sql_float" value="#form.RHOLengEscr5#"><cfelse>null</cfif> 
						, <cfif isdefined("form.RHOOtroIdioma5") and len(trim(form.RHOOtroIdioma5))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHOOtroIdioma5#"><cfelse>null</cfif>
						, <cfif isdefined("form.RHOLengLect5") and len(trim(form.RHOLengLect5))><cfqueryparam cfsqltype="cf_sql_float" value="#form.RHOLengLect5#"><cfelse>null</cfif>
						)
					<cf_dbidentity1 datasource="#Session.DSN#">
				</cfquery>
				<cf_dbidentity2 datasource="#Session.DSN#" name="ABC_datosOferente">
				<cfset vNewEmpl = ABC_datosOferente.identity>
				<cfif isdefined("Form.rutafoto") and form.rutafoto NEQ "">
					<cfquery name="ABC_OferentesImagen" datasource="#Session.DSN#">
						insert into RHImagenOferente(Ecodigo,RHOid, foto, BMUsucodigo)
						values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#vNewEmpl#">, 
						<cf_dbupload filefield="rutafoto" accept="image/*" datasource="#Session.DSN#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">)
					</cfquery>
				</cfif>
			</cftransaction>
			<cfset modo="Cambio">
				
		<cfelseif isdefined("Form.Baja")>
			<cfquery name="_deleteImagen" datasource="#Session.DSN#">
				delete from RHImagenOferente
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				  and RHOid  = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHOid#">
			</cfquery>
				
			<cfquery name="_deleteDatosOferentes" datasource="#Session.DSN#">
				delete from DatosOferentes						
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				  and RHOid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHOid#">
			</cfquery>
			<cfset modo="ALTA">
			<cfset action = "/cfmx/rh/Reclutamiento/catalogos/lista-oferentes.cfm">

		<cfelseif isdefined("Form.Cambio")>
			<!--- <cfquery datasource="#session.dsn#" name="datos_actuales">
				select id_direccion   from DatosOferentes
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and RHOid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHOid#">
			</cfquery> --->
			<cfif  isdefined("direccion.id_direccion") and len(trim(direccion.id_direccion))>
				<cf_direccion action="readform" name="direccion">
				<cf_direccion action="update" data="#direccion#" name="direccion">
			<cfelse>
				<cf_direccion action="readform" name="direccion">
				<cf_direccion action="insert" data="#direccion#" name="direccion">
			</cfif>
			
			<cfquery name="ABC_datosOferente" datasource="#Session.DSN#">
				update DatosOferentes set
					Ecodigo 		  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					NTIcodigo		  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.NTIcodigo#">,
					RHOidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHOidentificacion#">,
					RHOnombre 		  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHOnombre#">,								
					RHOapellido1 	  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHOapellido1#">,								
					RHOapellido2 	  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHOapellido2#">,								
					<!--- RHOdireccion 	  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHOdireccion#">,	 --->	
					id_direccion 	  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#direccion.id_direccion#">,														
					RHOtelefono1	  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHOtelefono1#">,
					RHOtelefono2	  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHOtelefono2#">,
					RHOemail		  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHOemail#">,
					RHOcivil 		  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.RHOcivil#">,								
					RHOfechanac 	  = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParsedateTime(form.RHOfechanac)#">,
					RHOsexo 		  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHOsexo#">
					<cfif isdefined('form.RHOobs1')>
					,RHOobs1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHOobs1#" null="#Len(Trim(Form.RHOobs1)) EQ 0#">
					</cfif>								
					<cfif isdefined('form.RHOobs2')>
					,RHOobs2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHOobs2#" null="#Len(Trim(Form.RHOobs2)) EQ 0#">
					</cfif>								
					<cfif isdefined('form.RHOobs3')>
					,RHOobs3 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHOobs3#" null="#Len(Trim(Form.RHOobs3)) EQ 0#">
					</cfif>
					<cfif isdefined('form.RHOdato1')>
					,RHOdato1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHOdato1#" null="#Len(Trim(Form.RHOdato1)) EQ 0#">
					</cfif>								
					<cfif isdefined('form.RHOdato2')>
					,RHOdato2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHOdato2#" null="#Len(Trim(Form.RHOdato2)) EQ 0#">
					</cfif>								
					<cfif isdefined('form.RHOdato3')>
					,RHOdato3 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHOdato3#" null="#Len(Trim(Form.RHOdato3)) EQ 0#">
					</cfif>								
					<cfif isdefined('form.RHOdato4')>
					,RHOdato4 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHOdato4#" null="#Len(Trim(Form.RHOdato4)) EQ 0#">
					</cfif>
					<cfif isdefined('form.RHOdato5')>
					,RHOdato5 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHOdato5#" null="#Len(Trim(Form.RHOdato5)) EQ 0#">
					</cfif>
					<cfif isdefined('form.RHOinfo1')>
					,RHOinfo1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHOinfo1#" null="#Len(Trim(Form.RHOinfo1)) EQ 0#">
					</cfif>
					<cfif isdefined('form.RHOinfo2')>
					,RHOinfo2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHOinfo2#" null="#Len(Trim(Form.RHOinfo2)) EQ 0#">
					</cfif>
					<cfif isdefined('form.RHOinfo3')>
					,RHOinfo3 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHOinfo3#" null="#Len(Trim(Form.RHOinfo3)) EQ 0#">
					</cfif>
					, Ppais = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ppais#">
					,BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
					,RHOfechaRecep  = <cfif isdefined("form.RHOfechaRecep") and len(trim(form.RHOfechaRecep))><cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParsedateTime(form.RHOfechaRecep)#"><cfelse>null</cfif>
					,RHOfechaIngr 	= <cfif isdefined("form.RHOfechaIngr") and len(trim(form.RHOfechaIngr))><cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParsedateTime(form.RHOfechaIngr)#"><cfelse>null</cfif>
					,RHOPrenteInf 	= <cfif isdefined("form.RHOPrenteInf") and len(trim(form.RHOPrenteInf))><cfqueryparam cfsqltype="cf_sql_float" value="#replace(form.RHOPrenteInf, ',','','all')#"><cfelse>null</cfif>
					,RHOPrenteSup 	= <cfif isdefined("form.RHOPrenteSup") and len(trim(form.RHOPrenteSup))><cfqueryparam cfsqltype="cf_sql_float" value="#replace(form.RHOPrenteSup, ',','','all')#"><cfelse>null</cfif>
					<cfif isDefined("Form.RHOPosViajar")>
					  ,RHOPosViajar 	=<cfqueryparam cfsqltype="cf_sql_integer" value="1">
					<cfelse>
					  ,RHOPosViajar 	=<cfqueryparam cfsqltype="cf_sql_integer" value="0">
					</cfif>	
					<cfif isDefined("Form.RHOPosTralado")>
					  ,RHOPosTralado 	=<cfqueryparam cfsqltype="cf_sql_integer" value="1">
					<cfelse>
					  ,RHOPosTralado 	=<cfqueryparam cfsqltype="cf_sql_integer" value="0">
					</cfif>	
					<cfif isDefined("Form.RHORefValida")>
					  ,RHORefValida 	=<cfqueryparam cfsqltype="cf_sql_integer" value="1">
					<cfelse>
					  ,RHORefValida 	=<cfqueryparam cfsqltype="cf_sql_integer" value="0">
					</cfif>						
					,RHOLengOral1 	= <cfif isdefined("form.RHOLengOral1") and len(trim(form.RHOLengOral1))> <cfqueryparam cfsqltype="cf_sql_float" value="#form.RHOLengOral1#"><cfelse>null</cfif>
					,RHOLengOral2 	= <cfif isdefined("form.RHOLengOral2") and len(trim(form.RHOLengOral2))> <cfqueryparam cfsqltype="cf_sql_float" value="#form.RHOLengOral2#"><cfelse>null</cfif>
					,RHOLengOral3 	= <cfif isdefined("form.RHOLengOral3") and len(trim(form.RHOLengOral3))> <cfqueryparam cfsqltype="cf_sql_float" value="#form.RHOLengOral3#"><cfelse>null</cfif>
					,RHOLengOral4 	= <cfif isdefined("form.RHOLengOral4") and len(trim(form.RHOLengOral4))> <cfqueryparam cfsqltype="cf_sql_float" value="#form.RHOLengOral4#"><cfelse>null</cfif>
					,RHOLengOral5 	= <cfif isdefined("form.RHOLengOral5") and len(trim(form.RHOLengOral5))> <cfqueryparam cfsqltype="cf_sql_float" value="#form.RHOLengOral5#"><cfelse>null</cfif>	
					,RHOLengEscr1 	= <cfif isdefined("form.RHOLengEscr1") and len(trim(form.RHOLengEscr1))> <cfqueryparam cfsqltype="cf_sql_float" value="#form.RHOLengEscr1#"><cfelse>null</cfif>
					,RHOLengEscr2 	= <cfif isdefined("form.RHOLengEscr2") and len(trim(form.RHOLengEscr2))> <cfqueryparam cfsqltype="cf_sql_float" value="#form.RHOLengEscr2#"><cfelse>null</cfif>
					,RHOLengEscr3 	= <cfif isdefined("form.RHOLengEscr3") and len(trim(form.RHOLengEscr3))> <cfqueryparam cfsqltype="cf_sql_float" value="#form.RHOLengEscr3#"><cfelse>null</cfif>
					,RHOLengEscr4 	= <cfif isdefined("form.RHOLengEscr4") and len(trim(form.RHOLengEscr4))> <cfqueryparam cfsqltype="cf_sql_float" value="#form.RHOLengEscr4#"><cfelse>null</cfif>
					,RHOLengEscr5 	= <cfif isdefined("form.RHOLengEscr5") and len(trim(form.RHOLengEscr5))> <cfqueryparam cfsqltype="cf_sql_float" value="#form.RHOLengEscr5#"><cfelse>null</cfif>
					,RHOLengLect1 	= <cfif isdefined("form.RHOLengLect1") and len(trim(form.RHOLengLect1))> <cfqueryparam cfsqltype="cf_sql_float" value="#form.RHOLengLect1#"><cfelse>null</cfif>
					,RHOLengLect2 	= <cfif isdefined("form.RHOLengLect2") and len(trim(form.RHOLengLect2))> <cfqueryparam cfsqltype="cf_sql_float" value="#form.RHOLengLect2#"><cfelse>null</cfif>
					,RHOLengLect3 	= <cfif isdefined("form.RHOLengLect3") and len(trim(form.RHOLengLect3))> <cfqueryparam cfsqltype="cf_sql_float" value="#form.RHOLengLect3#"><cfelse>null</cfif>
					,RHOLengLect4 	= <cfif isdefined("form.RHOLengLect4") and len(trim(form.RHOLengLect4))> <cfqueryparam cfsqltype="cf_sql_float" value="#form.RHOLengLect4#"><cfelse>null</cfif>	
					,RHOLengLect5 	= <cfif isdefined("form.RHOLengLect5") and len(trim(form.RHOLengLect5))> <cfqueryparam cfsqltype="cf_sql_float" value="#form.RHOLengLect5#"><cfelse>null</cfif>
					,RHOIdioma1 	= <cfif isdefined("form.RHOIdioma1")   and len(trim(form.RHOIdioma1))> <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHOIdioma1#"><cfelse>null</cfif>
					,RHOIdioma2 	= <cfif isdefined("form.RHOIdioma2")   and len(trim(form.RHOIdioma2))> <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHOIdioma2#"><cfelse>null</cfif>
					,RHOIdioma3 	= <cfif isdefined("form.RHOIdioma3")   and len(trim(form.RHOIdioma3))> <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHOIdioma3#"><cfelse>null</cfif>
					,RHOIdioma4 	= <cfif isdefined("form.RHOIdioma4")   and len(trim(form.RHOIdioma4))> <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHOIdioma4#"><cfelse>null</cfif>
					,RHOOtroIdioma5 = <cfif isdefined("form.RHOOtroIdioma5") and len(trim(form.RHOOtroIdioma5))>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHOOtroIdioma5#"><cfelse>null</cfif>
					,RHOMonedaPrt   = <cfif isdefined("form.RHOMonedaPrt") and len(trim(form.RHOMonedaPrt))> <cfqueryparam cfsqltype="cf_sql_char"    value="#form.RHOMonedaPrt#"><cfelse>null</cfif>				
					<cfif isDefined("Form.RHOEntrevistado")>
						,RHOEntrevistado 	= <cfqueryparam cfsqltype="cf_sql_integer" value="1">
						,RHOfechaEntrevista = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParsedateTime(form.RHOfechaEntrevista)#">
						,RHORealizadaPor    = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHORealizadaPor#">
					<cfelse>
						,RHOEntrevistado 	= <cfqueryparam cfsqltype="cf_sql_integer" value="0">
						,RHOfechaEntrevista = null
						,RHORealizadaPor    = null
					</cfif>
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and RHOid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHOid#">
			</cfquery>
			<cfif isdefined("Form.rutafoto") and form.rutafoto NEQ "">
				<cfquery name="Existe_RHImagenOferente" datasource="#Session.DSN#">
					select * 
					from RHImagenOferente
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					  and RHOid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHOid#">
				</cfquery>
				<cfif isdefined("Existe_RHImagenOferente") and Existe_RHImagenOferente.RecordCount NEQ 0>
					<cfquery name="ABC_RHImagenOferente" datasource="#Session.DSN#">
						update RHImagenOferente 
						   set foto    = <cf_dbupload filefield="rutafoto" accept="image/*" datasource="#Session.DSN#">,
						   BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						  and RHOid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHOid#">
					</cfquery>
				<cfelse>
					<cfquery name="ABC_RHImagenOferente" datasource="#Session.DSN#">
						insert into RHImagenOferente(Ecodigo, RHOid, foto, BMUsucodigo)
						values (<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
							    <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHOid#">, 
						<cf_dbupload filefield="rutafoto" accept="image/*" datasource="#Session.DSN#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">)
					</cfquery>
				</cfif>
			</cfif>
			<cfset modo="CAMBIO">
		<cftransaction action="commit">
	</cfif>
	<cfelse>
		<cfset modo = "ALTA">
		<cfset action = "/cfmx/rh/Reclutamiento/catalogos/OferenteExterno.cfm">
	</cfif>

<form action="<cfoutput>#action#</cfoutput>" method="post" name="sql">
	<input name="modo"   type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<cfif isdefined("Form.Baja")>
		<input name="sel" type="hidden" value="0">
	<cfelse>
		<input name="sel" type="hidden" value="1">
	</cfif>
	<cfif modo EQ 'CAMBIO'>
		<input name="RHOid" type="hidden" 
		value="<cfoutput><cfif isdefined("Form.Cambio") and isdefined("form.RHOid")>#form.RHOid#<cfelseif isdefined('vNewEmpl') and Len(Trim(vNewEmpl)) NEQ 0>#vNewEmpl#</cfif></cfoutput>">	
	</cfif>
	<cfif isdefined("Form.RegCon")>
		<cfoutput>
			<input name="RHCconcurso" type="hidden" value="#Form.RHCconcurso#">
			<input name="RegCon" type="hidden" value="#Form.RegCon#">
		</cfoutput>
	</cfif>
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
