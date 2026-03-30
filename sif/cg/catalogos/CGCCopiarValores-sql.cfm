<title>
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_CopiaValores"
		Default="Copiar Valores"
		returnvariable="LB_CopiaValores"/>
		<cfoutput>#LB_CopiaValores#</cfoutput>
</title>
<cf_templatecss>
<cf_web_portlet_start titulo="#LB_CopiaValores#">

<cfif isdefined("form.BTNCOPIAR") and form.BTNCOPIAR eq "Copiar">

	<cfif isdefined("form.CGConductor") and form.CGConductor eq -1>
	
		<!--- Recorrido para todos los conductores --->
		<cfquery name="rsConductores" datasource="#session.dsn#">
			select CGCid, CGCdescripcion
			from CGConductores
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		</cfquery>

		<cfset hayerrores=0>
		<cfset LvarMsgError = "">
		<cfset LvarMsgCop = "">
		
		<cfloop query="rsConductores">
		
			<cfset LvarCGCid = rsConductores.CGCid>
			<cfset LvarCGCdesc = rsConductores.CGCdescripcion>
			
			<!--- VERIFICA QUE LOS CAMPOS DE PERIODO,MES Y CONDUCTOR ESTEN DEFINIDOS --->
			
			<!--- VERIFICA QUE LOS DATOS ORIGEN EXISTEN --->
			<cfquery name="VerDatos" datasource="#session.dsn#">
			Select count(1) as haydatos
			from CGParamConductores
			where CGCid 	 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCGCid#">
			  and CGCperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CGCperiodo#">
			  and CGCmes 	 = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CGCmes#">
			</cfquery>
		
			<cfif VerDatos.haydatos gt 0>
			
				<cfquery name="rsInsNuevos" datasource="#session.dsn#">
					Select	count(1) as TotalNuevos
					from CGParamConductores a
					where a.CGCid 	 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCGCid#">
					  and a.CGCperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CGCperiodo#">
					  and a.CGCmes 	 = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CGCmes#">				
					  and not exists (Select 1
					  				  from CGParamConductores b
									  where b.CGCid 	 = a.CGCid
									    and coalesce(b.PCDcatid,-1)   = coalesce(a.PCDcatid,-1)
										and coalesce(b.PCCDclaid,-1)  = coalesce(a.PCCDclaid,-1)
									    and b.CGCperiodo = <cfqueryparam value="#PERAUX#" cfsqltype="cf_sql_integer">
										and b.CGCmes 	 = <cfqueryparam value="#MESAUX#" cfsqltype="cf_sql_integer">)
				</cfquery>				
				<cfset LvarTotalnuevos = rsInsNuevos.TotalNuevos>
				<cfset LvarTotalviejos = 0>			
			
				<!--- INSERTA EN EL PERIODO-MES ACTUAL TODO LO QUE VIENE DEL ORIGEN QUE NO EXISTE --->
				<cfquery name="rstemp" datasource="#session.dsn#">
					insert into CGParamConductores (Ecodigo, 
													CGCperiodo, 
													CGCmes, 
													CGCid, 
													PCCDclaid, 
													PCDcatid, 
													CGCvalor, 
													BMUsucodigo)		
					
					Select	<cfqueryparam value="#session.ecodigo#" cfsqltype="cf_sql_integer">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#form.PERAUX#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#form.MESAUX#">,
							a.CGCid,
							a.PCCDclaid, 
							a.PCDcatid, 
							a.CGCvalor, 
							<cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">					
					from CGParamConductores a
					where a.CGCid 	 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCGCid#">
					  and a.CGCperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CGCperiodo#">
					  and a.CGCmes 	 = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CGCmes#">				
					  and not exists (Select 1
					  				  from CGParamConductores b
									  where b.CGCid 	 = a.CGCid
									    and coalesce(b.PCDcatid,-1)   = coalesce(a.PCDcatid,-1)
										and coalesce(b.PCCDclaid,-1)  = coalesce(a.PCCDclaid,-1)
									    and b.CGCperiodo = <cfqueryparam value="#PERAUX#" cfsqltype="cf_sql_integer">
										and b.CGCmes 	 = <cfqueryparam value="#MESAUX#" cfsqltype="cf_sql_integer">)
				</cfquery>				

				<!--- EN CASO DE SOBREESCRIBIR LOS DATOS, SE BORRA TODO LO QUE ESTA EN EL 
					  PERIODO-MES ACTUAL QUE EXISTE EN EL ORIGEN, PARA LUEGO INSERTAR LOS 
					  VALORES QUE TENIA EL ORGINEN 
				--->
				<cfif isdefined("form.chksobwr") and form.chksobwr eq 1>
			
					<!--- Borra lo que es igual en el periodo nuevo al viejo, 
						  verificando por llave 
					--->
					<cfquery name="rstemp" datasource="#session.dsn#">
					Delete from CGParamConductores
					where CGCid 	 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCGCid#">
					  and CGCperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.PERAUX#">
					  and CGCmes 	 = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.MESAUX#">				
					  and exists(Select 1
								from CGParamConductores b
								where b.CGCid	   = CGParamConductores.CGCid	
								  and b.CGCperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CGCperiodo#">
								  and b.CGCmes	   = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CGCmes#">
								  and coalesce(b.PCDcatid,-1)   = coalesce(CGParamConductores.PCDcatid,-1)
								  and coalesce(b.PCCDclaid,-1)  = coalesce(CGParamConductores.PCCDclaid,-1)) 
					</cfquery>
					
					<cfquery name="rsInsViejos" datasource="#session.dsn#">
						Select	count(1) as TotalViejos
						from CGParamConductores a
						where a.CGCid 	 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCGCid#">
						  and a.CGCperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CGCperiodo#">
						  and a.CGCmes 	 = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CGCmes#">				
						  and not exists (Select 1
									  from CGParamConductores b
									  where b.CGCid 	 = a.CGCid
										and coalesce(b.PCDcatid,-1)  = coalesce(a.PCDcatid,-1)
										and coalesce(b.PCCDclaid,-1) = coalesce(a.PCCDclaid,-1)
										and b.CGCperiodo = <cfqueryparam value="#PERAUX#" cfsqltype="cf_sql_integer">
										and b.CGCmes 	 = <cfqueryparam value="#MESAUX#" cfsqltype="cf_sql_integer">)
					</cfquery>							
					<cfset LvarTotalviejos = rsInsViejos.TotalViejos>					
					
					<cfquery name="rstemp" datasource="#session.dsn#">
						insert into CGParamConductores (Ecodigo, 
														CGCperiodo, 
														CGCmes, 
														CGCid, 
														PCCDclaid, 
														PCDcatid, 
														CGCvalor, 
														BMUsucodigo)		
						
						Select	<cfqueryparam value="#session.ecodigo#" cfsqltype="cf_sql_integer">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#form.PERAUX#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#form.MESAUX#">,
								a.CGCid,
								a.PCCDclaid, 
								a.PCDcatid, 
								a.CGCvalor, 
								<cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">					
						from CGParamConductores a
						where a.CGCid 	 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCGCid#">
						  and a.CGCperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CGCperiodo#">
						  and a.CGCmes 	 = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CGCmes#">				
						  and not exists (Select 1
									  from CGParamConductores b
									  where b.CGCid 	 = a.CGCid
										and coalesce(b.PCDcatid,-1)  = coalesce(a.PCDcatid,-1)
										and coalesce(b.PCCDclaid,-1) = coalesce(a.PCCDclaid,-1)
										and b.CGCperiodo = <cfqueryparam value="#PERAUX#" cfsqltype="cf_sql_integer">
										and b.CGCmes 	 = <cfqueryparam value="#MESAUX#" cfsqltype="cf_sql_integer">)
					</cfquery>
					
				</cfif>	

				<cfoutput>
				<cfset LvarMsgCop = LvarMsgCop & "<br>" & "Se copiaron " & #LvarTotalnuevos# & " registros para el Conductor (" & #LvarCGCdesc# & ") y se sobreescribieron " & #LvarTotalviejos# & " registros">
				</cfoutput>
				
			<cfelse>
				<cfset hayerrores=1>
				<cfoutput>
				<cfset LvarMsgError = LvarMsgError & "<br>" & "No hay datos parametrizados del conductor (" & #LvarCGCdesc# & ") para el periodo-mes (" & #form.CGCperiodo# & "-" & #form.CGCmes# & ")">
				</cfoutput>
			</cfif>
		
		</cfloop>
		
		<table cellpadding="0" cellspacing="0" align="center">
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td align="left">
				<strong>INFORMACION DEL COPIADO MASIVO:</strong> <br><cfoutput>#LvarMsgCop#</cfoutput>
			</td>
		</tr>		
		<cfif isdefined("hayerrores") and hayerrores eq 1>			
			<tr>
				<td align="left">
					<br><cfoutput>#LvarMsgError#</cfoutput>
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td align="center">
					<input type="button" name="btnReg" value="Regresar" onClick="javascript:history.back();">
					<input type="button" name="btnReg" value="Cerrar" onClick="javascript:window.close();window.opener.location.reload();">				
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			
		</cfif>
		</table>
		
	<cfelse>

		<!--- Recorrido para el conductor específico --->

		<!--- VERIFICA QUE LOS CAMPOS DE PERIODO,MES Y CONDUCTOR ESTEN DEFINIDOS --->
		<cfquery name="VerDatos" datasource="#session.dsn#">
		Select count(1) as haydatos
		from CGParamConductores
		where CGCid 	 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CGConductor#">
		  and CGCperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CGCperiodo#">
		  and CGCmes 	 = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CGCmes#">
		</cfquery>
	
		<cfif VerDatos.haydatos eq 0>
		
			<table cellpadding="0" cellspacing="0" align="center">
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td align="center">
					<strong>ERROR:</strong> <br>No hay datos parametrizados del conductor para el periodo-mes indicado
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td align="center">
					<input type="button" name="btnReg" value="Regresar" onClick="javascript:history.back();">
					<input type="button" name="btnReg" value="Cerrar" onClick="javascript:window.close();window.opener.location.reload();">				
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			</table>
		<cfelse>
			
			<cfquery name="rsInsNuevos" datasource="#session.dsn#">
				Select	count(1) as TotalNuevos
				from CGParamConductores
				where CGCid 	 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CGConductor#">
				  and CGCperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CGCperiodo#">
				  and CGCmes 	 = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CGCmes#">
				  and not exists (Select 1
								  from CGParamConductores b
								  where b.CGCid 	 = CGParamConductores.CGCid
									and coalesce(b.PCDcatid,-1)   = coalesce(CGParamConductores.PCDcatid,-1)
									and coalesce(b.PCCDclaid,-1)  = coalesce(CGParamConductores.PCCDclaid,-1)
									and b.CGCperiodo = <cfqueryparam value="#form.PERAUX#" cfsqltype="cf_sql_integer">
									and b.CGCmes 	 = <cfqueryparam value="#form.MESAUX#" cfsqltype="cf_sql_integer">)			
			</cfquery>			
			<cfset LvarTotalNuevos = rsInsNuevos.TotalNuevos>
			<cfset LvarTotalViejos = 0>			
			
			<cfquery name="rstemp" datasource="#session.dsn#">
				insert into CGParamConductores (Ecodigo, 
												CGCperiodo, 
												CGCmes, 
												CGCid, 
												PCCDclaid, 
												PCDcatid, 
												CGCvalor, 
												BMUsucodigo)		
				
				Select	<cfqueryparam value="#session.ecodigo#" cfsqltype="cf_sql_integer">,
						<cfqueryparam value="#PERAUX#" cfsqltype="cf_sql_integer">,
						<cfqueryparam value="#MESAUX#" cfsqltype="cf_sql_integer">,
						CGCid,
						PCCDclaid, 
						PCDcatid, 
						CGCvalor, 
						<cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">					
				from CGParamConductores
				where CGCid 	 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CGConductor#">
				  and CGCperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CGCperiodo#">
				  and CGCmes 	 = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CGCmes#">
				  and not exists (Select 1
								  from CGParamConductores b
								  where b.CGCid 	 = CGParamConductores.CGCid
									and coalesce(b.PCDcatid,-1)   = coalesce(CGParamConductores.PCDcatid,-1)
									and coalesce(b.PCCDclaid,-1)  = coalesce(CGParamConductores.PCCDclaid,-1)
									and b.CGCperiodo = <cfqueryparam value="#form.PERAUX#" cfsqltype="cf_sql_integer">
									and b.CGCmes 	 = <cfqueryparam value="#form.MESAUX#" cfsqltype="cf_sql_integer">)			
			</cfquery>
			
			<!--- EN CASO DE SOBREESCRIBIR LOS DATOS, SE BORRA TODO LO QUE ESTA EN EL 
				  PERIODO-MES ACTUAL QUE EXISTE EN EL ORIGEN, PARA LUEGO INSERTAR LOS 
				  VALORES QUE TENIA EL ORGINEN 
			--->
			<cfif isdefined("form.chksobwr") and form.chksobwr eq 1>
			
			    
				<cfquery name="rstemp" datasource="#session.dsn#">
					Delete from CGParamConductores
					where CGCid 	 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CGConductor#">
					  and CGCperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.PERAUX#">
					  and CGCmes 	 = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.MESAUX#">				
					  and exists(Select 1
								from CGParamConductores b
								where b.CGCid	   = CGParamConductores.CGCid	
								  and b.CGCperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CGCperiodo#">
								  and b.CGCmes	   = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CGCmes#">
								  and coalesce(b.PCDcatid,-1)   = coalesce(CGParamConductores.PCDcatid,-1)
								  and coalesce(b.PCCDclaid,-1)  = coalesce(CGParamConductores.PCCDclaid,-1))
				</cfquery>
				
				<cfquery name="rsInsViejos" datasource="#session.dsn#">
					Select count(1) as TotalViejos
					from CGParamConductores a
					where a.CGCid 	 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CGConductor#">
					  and a.CGCperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CGCperiodo#">
					  and a.CGCmes 	 = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CGCmes#">				
					  and not exists (Select 1
								  from CGParamConductores b
								  where b.CGCid 	 = a.CGCid
									and coalesce(b.PCDcatid,-1) = coalesce(a.PCDcatid,-1)
									and coalesce(b.PCCDclaid,-1)= coalesce(a.PCCDclaid,-1)
									and b.CGCperiodo = <cfqueryparam value="#PERAUX#" cfsqltype="cf_sql_integer">
									and b.CGCmes 	 = <cfqueryparam value="#MESAUX#" cfsqltype="cf_sql_integer">)				
				</cfquery>	
				<cfset LvarTotalViejos = rsInsViejos.TotalViejos>				
				
				<cfquery name="rstemp" datasource="#session.dsn#">
					insert into CGParamConductores (Ecodigo, 
													CGCperiodo, 
													CGCmes, 
													CGCid, 
													PCCDclaid, 
													PCDcatid, 
													CGCvalor, 
													BMUsucodigo)		
					
					Select	<cfqueryparam value="#session.ecodigo#" cfsqltype="cf_sql_integer">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#form.PERAUX#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#form.MESAUX#">,
							a.CGCid,
							a.PCCDclaid, 
							a.PCDcatid, 
							a.CGCvalor, 
							<cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">					
					from CGParamConductores a
					where a.CGCid 	 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CGConductor#">
					  and a.CGCperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CGCperiodo#">
					  and a.CGCmes 	 = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CGCmes#">				
					  and not exists (Select 1
								  from CGParamConductores b
								  where b.CGCid 	 = a.CGCid
									and coalesce(b.PCDcatid,-1) = coalesce(a.PCDcatid,-1)
									and coalesce(b.PCCDclaid,-1)= coalesce(a.PCCDclaid,-1)
									and b.CGCperiodo = <cfqueryparam value="#PERAUX#" cfsqltype="cf_sql_integer">
									and b.CGCmes 	 = <cfqueryparam value="#MESAUX#" cfsqltype="cf_sql_integer">)				
				</cfquery>				
			
			</cfif>

			<cfquery name="rsInfoCond" datasource="#session.dsn#">
			Select CGCdescripcion
			from CGConductores
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
			  and CGCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CGConductor#">
			</cfquery>
	
		
			<cfoutput>
			<table cellpadding="0" cellspacing="0" align="center">
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td align="left">
					<strong>INFORMACION DEL COPIADO MASIVO:</strong><br><br>Se copiaron #LvarTotalNuevos# registros y se sobreescribieron #LvarTotalViejos# registros para el conductor (#rsInfoCond.CGCdescripcion#) en el periodo-mes(#form.PERAUX#-#form.MESAUX#).<br>
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td align="center">
					<input type="button" name="btnReg" value="Regresar" onClick="javascript:history.back();">
					<input type="button" name="btnReg" value="Cerrar" onClick="javascript:window.close();window.opener.location.reload();">				
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			</table>		
			</cfoutput>
			
		</cfif>
		
	</cfif>

</cfif>
<cf_web_portlet_end>