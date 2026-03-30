
<cfif IsDefined("Form.logout") >
	<cfset form.RHOid        = "">
	<cfset session.CEcodigo = "">
	<cfset session.Estado = "">
	<cfset session.usuario 	= "">
	<cflogout>
	<cflocation  url="index.cfm"  addtoken="no">
</cfif>



<cfif isdefined("form.AccionAEjecutar") and len(trim(form.AccionAEjecutar)) gt 0>
	<cfif form.AccionAEjecutar eq 'ADD-MOD'>
		<!--- ******************************************************************* --->
		<!--- **************     DATOS PERSONALES           ********************* --->
		<!--- ******************************************************************* --->
		<cfif isdefined("session.RHOid") and len(trim(session.RHOid)) gt 0>
			<!--- actualiza al oferente --->
				<cfif  isdefined("direccion.id_direccion") and len(trim(direccion.id_direccion))>
					<cf_direccion action="readform" name="direccion">
					<cf_direccion action="update" data="#direccion#" name="direccion">
				<cfelse>
					<cf_direccion action="readform" name="direccion">
					<cf_direccion action="insert" data="#direccion#" name="direccion">
				</cfif>
				<cftransaction>
					
					<cfquery name="ABC_datosOferente" datasource="#Session.DSN#">
						update DatosOferentes set
							Ecodigo 		  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
							NTIcodigo		  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.NTIcodigo#">,
							RHOidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHOidentificacion#">,
							RHOnombre 		  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHOnombre#">,								
							RHOapellido1 	  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHOapellido1#">,								
							RHOapellido2 	  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHOapellido2#">,								
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
							,RHOLengEscr1 	= <cfif isdefined("form.RHOLengEscr1") and len(trim(form.RHOLengEscr1))> <cfqueryparam cfsqltype="cf_sql_float" value="#form.RHOLengEscr1#"><cfelse>null</cfif>
							,RHOLengEscr2 	= <cfif isdefined("form.RHOLengEscr2") and len(trim(form.RHOLengEscr2))> <cfqueryparam cfsqltype="cf_sql_float" value="#form.RHOLengEscr2#"><cfelse>null</cfif>
							,RHOLengEscr3 	= <cfif isdefined("form.RHOLengEscr3") and len(trim(form.RHOLengEscr3))> <cfqueryparam cfsqltype="cf_sql_float" value="#form.RHOLengEscr3#"><cfelse>null</cfif>
							,RHOLengLect1 	= <cfif isdefined("form.RHOLengLect1") and len(trim(form.RHOLengLect1))> <cfqueryparam cfsqltype="cf_sql_float" value="#form.RHOLengLect1#"><cfelse>null</cfif>
							,RHOLengLect2 	= <cfif isdefined("form.RHOLengLect2") and len(trim(form.RHOLengLect2))> <cfqueryparam cfsqltype="cf_sql_float" value="#form.RHOLengLect2#"><cfelse>null</cfif>
							,RHOLengLect3 	= <cfif isdefined("form.RHOLengLect3") and len(trim(form.RHOLengLect3))> <cfqueryparam cfsqltype="cf_sql_float" value="#form.RHOLengLect3#"><cfelse>null</cfif>
							,RHOIdioma1 	= <cfif isdefined("form.RHOidioma1")   and len(trim(form.RHOidioma1))> <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHOidioma1#"><cfelse>null</cfif>
							,RHOIdioma2 	= <cfif isdefined("form.RHOidioma2")   and len(trim(form.RHOidioma2))> <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHOidioma2#"><cfelse>null</cfif>
							,RHOIdioma3 	= <cfif isdefined("form.RHOidioma3")   and len(trim(form.RHOidioma3))> <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHOidioma3#"><cfelse>null</cfif>
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
						  and RHOid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.RHOid#">
					</cfquery>
					<cfif isdefined("Form.rutafoto") and form.rutafoto NEQ "">
						<cfquery name="Existe_RHImagenOferente" datasource="#Session.DSN#">
							select * 
							from RHImagenOferente
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							  and RHOid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.RHOid#">
						</cfquery>
						<cfif isdefined("Existe_RHImagenOferente") and Existe_RHImagenOferente.RecordCount NEQ 0>
							<cfquery name="ABC_RHImagenOferente" datasource="#Session.DSN#">
								update RHImagenOferente 
								   set foto    = <cf_dbupload filefield="rutafoto" accept="image/*" datasource="#Session.DSN#">,
								   BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
								where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								  and RHOid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.RHOid#">
							</cfquery>
						<cfelse>
							<cfquery name="ABC_RHImagenOferente" datasource="#Session.DSN#">
								insert into RHImagenOferente(Ecodigo, RHOid, foto, BMUsucodigo)
								values (<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.RHOid#">, 
								<cf_dbupload filefield="rutafoto" accept="image/*" datasource="#Session.DSN#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">)
							</cfquery>
						</cfif>
					</cfif>
			</cftransaction>	
		<cfelse>
			<cf_direccion action="readform" name="direccion">
			<cf_direccion action="insert" data="#direccion#" name="direccion">
			<cftransaction>
				<cfquery name="ABC_datosOferente" datasource="#Session.DSN#">
					insert into DatosOferentes 
					(Ecodigo, NTIcodigo, RHOidentificacion, 
						RHOnombre, RHOapellido1, RHOapellido2, 
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
				RHOMonedaPrt)
					values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.NTIcodigo#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHOidentificacion#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHOnombre#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHOapellido1#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHOapellido2#">,
   					    <cfqueryparam cfsqltype="cf_sql_numeric" value="#direccion.id_direccion#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHOtelefono1#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHOtelefono2#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHOemail#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHOcivil#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParsedateTime(form.RHOfechanac)#">,
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
						,<cfif isdefined("form.RHOfechaRecep") and len(trim(form.RHOfechaRecep))><cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParsedateTime(form.RHOfechaRecep)#"><cfelse>null</cfif>
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
						, <cfif isdefined("form.RHOidioma1") and len(trim(form.RHOidioma1))><cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHOidioma1#"><cfelse>null</cfif>
						, <cfif isdefined("form.RHOidioma2") and len(trim(form.RHOidioma2))><cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHOidioma2#"><cfelse>null</cfif>
						, <cfif isdefined("form.RHOidioma3") and len(trim(form.RHOidioma3))><cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHOidioma3#"><cfelse>null</cfif>
						
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
						)
					<cf_dbidentity1  datasource="#Session.DSN#">
				</cfquery>
				<cf_dbidentity2  datasource="#Session.DSN#" name="ABC_datosOferente">
				<cfset session.RHOid = ABC_datosOferente.identity>	
				<cfif isdefined("Form.rutafoto") and form.rutafoto NEQ "">
					<cfquery name="ABC_OferentesImagen" datasource="#Session.DSN#">
						insert into RHImagenOferente(Ecodigo,RHOid, foto, BMUsucodigo)
						values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.RHOid#">, 
						<cf_dbupload filefield="rutafoto" accept="image/*" datasource="#Session.DSN#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">)
					</cfquery>
				</cfif>
			</cftransaction>
		</cfif>
		<!--- ******************************************************************* --->
		<!--- **************     EXPERIENCIA LABORAL        ********************* --->
		<!--- ******************************************************************* --->
		<cfif isdefined("Form.RHEEid") and len(trim(Form.RHEEid)) gt 0>
			<cfquery name="update" datasource="#Session.DSN#">
				update RHExperienciaEmpleado
				set	RHEEnombreemp = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHEEnombreemp#">,
					RHEEtelemp = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHEEtelemp#">,
					RHOPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHOPid#">,
					RHEEAnnosLab  = <cfif isdefined("form.RHEEAnnosLab") and len(trim(form.RHEEAnnosLab))><cfqueryparam cfsqltype="cf_sql_float" value="#replace(form.RHEEAnnosLab, ',','','all')#"><cfelse>null</cfif>,
					RHEEpuestodes = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHOPDescripcion#">,
					RHEEfechaini = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(form.anoIni,form.mesIni,01)#">,
					RHEEfecharetiro = <cfif isdefined("form.Actualmente")><cfqueryparam cfsqltype="cf_sql_timestamp" value="01/01/6100"><cfelse><cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(form.anoFin,form.mesFin,01)#"></cfif>,
					Actualmente = <cfif isdefined("form.Actualmente")>1<cfelse>0</cfif>,
					RHEEfunclogros = <cfif isdefined("form.RHEEfunclogros") and len(trim(form.RHEEfunclogros))><cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.RHEEfunclogros#"><cfelse>null</cfif>,
					RHEEmotivo = <cfif isdefined("form.RHEEmotivo") and len(trim(form.RHEEmotivo))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEmotivo#"><cfelse>50</cfif>
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" >
					and RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEid#" >
					and RHOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.RHOid#">
			</cfquery> 
		<cfelse>
			<cfif isdefined("Form.RHEEnombreemp") 	and len(trim(Form.RHEEnombreemp)) gt 0 and
			  isdefined("Form.RHEEtelemp")    		and len(trim(Form.RHEEtelemp)) gt 0 and
			  isdefined("Form.RHOPDescripcion")    	and len(trim(Form.RHOPDescripcion)) gt 0 and 
			  isdefined("Form.anoIni")    			and len(trim(Form.anoIni)) gt 0 and
			  isdefined("Form.mesIni")    			and len(trim(Form.mesIni)) gt 0 
			>
			<cfquery name="insRHOPuesto" datasource="#Session.DSN#">
				select RHOPid from RHOPuesto
				where CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.CEcodigo#">
				and RHOPDescripcion = rtrim(ltrim('#Form.RHOPDescripcion#'))
			</cfquery>
		
			<cfif insRHOPuesto.recordCount eq 0  >
				<cfquery name="insRHOPuesto" datasource="#Session.DSN#">			
					insert INTO RHOPuesto (CEcodigo, RHOPDescripcion,BMfechaalta, BMUsucodigo)
					values 
					(	 #session.CEcodigo# , 
						 rtrim(ltrim('#Form.RHOPDescripcion#')), 
						 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">, 
						 #session.Usucodigo#) 
					<cf_dbidentity1  verificar_transaccion="false">	 
				</cfquery>
				<cf_dbidentity2  verificar_transaccion="false" name="insRHOPuesto"> 
		
				<cfset llaveExp = insRHOPuesto.identity>
			<cfelse>
				<cfset llaveExp = insRHOPuesto.RHOPid>
			</cfif>


				<cfquery name="insert" datasource="#Session.DSN#">
						insert into RHExperienciaEmpleado (DEid, RHOid, Ecodigo, RHEEnombreemp, RHEEtelemp,RHEEAnnosLab,RHOPid, RHEEpuestodes, RHEEfechaini, RHEEfecharetiro, Actualmente, RHEEfunclogros, BMUsucodigo, BMfecha, RHEEmotivo)
						values(	null,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.RHOid#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHEEnombreemp#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHEEtelemp#">,
								<cfif isdefined("form.RHEEAnnosLab") and len(trim(form.RHEEAnnosLab))><cfqueryparam cfsqltype="cf_sql_float" value="#replace(form.RHEEAnnosLab, ',','','all')#"><cfelse>null</cfif>,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#llaveExp#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHOPDescripcion#">,
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(form.anoIni,form.mesIni,01)#">,
								<cfif isdefined("form.Actualmente")><cfqueryparam cfsqltype="cf_sql_timestamp" value="01/01/6100"><cfelse><cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(form.anoFin,form.mesFin,01)#"></cfif>,
								<cfif isdefined("form.Actualmente")>1<cfelse>0</cfif>,
								<cfif isdefined("form.RHEEfunclogros") and len(trim(form.RHEEfunclogros))><cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.RHEEfunclogros#"><cfelse>null</cfif>,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
								<cfif isdefined("form.RHEEmotivo") and len(trim(form.RHEEmotivo))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEmotivo#"><cfelse>50</cfif>
								)
					</cfquery>		
			</cfif>	
		</cfif>
		<!--- ******************************************************************* --->
		<!--- **************     EDUCACION                  ********************* --->
		<!--- ******************************************************************* --->
		 <cfif isdefined("Form.RHEElinea") and len(trim(Form.RHEElinea)) gt 0>
			<cfquery name="update" datasource="#Session.DSN#">
				update RHEducacionEmpleado
				set RHEtitulo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHOTDescripcion#">,
					RHOTid    =	<cfif isdefined("form.RHOTid") and len(trim(form.RHOTid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHOTid#"><cfelse>null</cfif>,
					RHIAid = <cfif isdefined("form.RHIAid") and len(trim(form.RHIAid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHIAid#"><cfelse>null</cfif>,
					GAcodigo = 	<cfif isdefined("form.GAcodigo") and len(trim(form.GAcodigo))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GAcodigo#"><cfelse>null</cfif>,
					RHEotrains = <cfif isdefined("form.RHIAid") and not(len(trim(form.RHIAid))) and isdefined("form.RHEotrains") and len(trim(form.RHEotrains))>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHEotrains#">
						<cfelse>
							null
						</cfif>,
					RHEfechaini = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(form.anoIniE,form.mesIniE,01)#">,
					RHEfechafin = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(form.anoFinE,form.mesFinE,01)#">,
					RHEsinterminar = <cfif isdefined("form.RHEsinterminar")>1<cfelse>0</cfif>,
					RHECapNoFormal = <cfif isdefined("form.RHECapNoFormal") and len(trim(form.RHECapNoFormal))><cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.RHECapNoFormal#"><cfelse>null</cfif>
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" >
				  and RHEElinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEElinea#" >
				  and RHOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.RHOid#">
			</cfquery> 		 
		<cfelse>
			<cfif isdefined("Form.RHIAid") 	and len(trim(Form.RHIAid)) gt 0 or
			  isdefined("Form.RHEotrains")    	and len(trim(Form.RHEotrains)) gt 0 
			>
			
			<cfquery name="insTitulo" datasource="#Session.DSN#">
				select RHOTid from RHOTitulo
				where CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.CEcodigo#">
				and RHOTDescripcion = rtrim(ltrim('#Form.RHOTDescripcion#'))
			</cfquery>

			<cfif insTitulo.recordCount eq 0  >
				<cfquery name="insTitulo" datasource="#Session.DSN#">			
					insert INTO RHOTitulo (CEcodigo, RHOTDescripcion,BMfechaalta, BMUsucodigo)
					values 
					(	 #session.CEcodigo# , 
						 rtrim(ltrim('#Form.RHOTDescripcion#')), 
						 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">, 
						 #session.Usucodigo#) 
					<cf_dbidentity1  verificar_transaccion="false">	 
				</cfquery>
				<cf_dbidentity2  verificar_transaccion="false" name="insTitulo"> 
		
				<cfset llavetitulo = insTitulo.identity>
			<cfelse>
				<cfset llavetitulo = insTitulo.RHOTid>
			</cfif>
				
				
				<cfquery name="insert" datasource="#Session.DSN#">
					insert into RHEducacionEmpleado(DEid, RHOid, Ecodigo, RHIAid, GAcodigo, RHEotrains, RHEtitulo,RHOTid, RHEfechaini, RHEfechafin, RHEsinterminar, BMUsucodigo, BMfecha,RHECapNoFormal)
					values(	null,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.RHOid#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
							<cfif isdefined("form.RHIAid") and len(trim(form.RHIAid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHIAid#"><cfelse>null</cfif>,
							<cfif isdefined("form.GAcodigo") and len(trim(form.GAcodigo))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GAcodigo#"><cfelse>null</cfif>,
							<cfif isdefined("form.RHIAid") and not(len(trim(form.RHIAid))) and isdefined("form.RHEotrains") and len(trim(form.RHEotrains))>
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHEotrains#">
							<cfelse>
								null
							</cfif>,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHOTDescripcion#">,
							<cfif isdefined("llavetitulo") and len(trim(llavetitulo))><cfqueryparam cfsqltype="cf_sql_numeric" value="#llavetitulo#"><cfelse>null</cfif>,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(form.anoIniE,form.mesIniE,01)#">,
							<cfif isdefined("form.anoFinE") and len(trim(form.anoFinE)) and isdefined("form.mesFinE") and len(trim(form.mesFinE))>
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(form.anoFinE,form.mesFinE,01)#">
							<cfelse>
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(form.anoIniE,form.mesIniE,01)#">
							</cfif>,
							<cfif isdefined("form.RHEsinterminar")>1<cfelse>0</cfif>,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							<cfif isdefined("form.RHECapNoFormal") and len(trim(form.RHECapNoFormal))><cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.RHECapNoFormal#"><cfelse>null</cfif>
							)	
									
				</cfquery>	
			</cfif>		
		</cfif>
	<cfelseif form.AccionAEjecutar eq 'DEL-EDUC'>
		<cfquery name="delete" datasource="#Session.DSN#">
			delete RHEducacionEmpleado
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and RHEElinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEElinea#">
			  and RHOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.RHOid#">
		</cfquery> 
		<cfset form.RHEElinea = "">	
	<cfelseif form.AccionAEjecutar eq 'DEL-EXP'>
		<cfquery name="delete" datasource="#Session.DSN#">
			delete RHExperienciaEmpleado
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEid#">
 			  and RHOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.RHOid#">
		</cfquery> 
		<cfset form.RHEEid = "">
	</cfif>
</cfif>

<form action="index.cfm" method="post" name="sql">
	<cfoutput>
		<cfif isdefined("session.RHOid") and len(trim(session.RHOid)) gt 0>
				<input name="RHOid" type="hidden" value="#session.RHOid#">
		</cfif>
		<cfif isdefined("Form.RHEElinea") and len(trim(Form.RHEElinea)) gt 0>
				<input name="RHEElinea" type="hidden" value="#Form.RHEElinea#">
		</cfif>
		<cfif isdefined("Form.RHEEid") and len(trim(Form.RHEEid)) gt 0>
				<input name="RHEEid" type="hidden" value="#Form.RHEEid#">
		</cfif>
	</cfoutput>

</form>
<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
