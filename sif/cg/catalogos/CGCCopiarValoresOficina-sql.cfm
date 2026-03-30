<title>
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_CopiaValoresOf"
		Default="Copiar Valores Oficinas"
		returnvariable="LB_CopiaValoresOf"/>
		<cfoutput>#LB_CopiaValoresOf#</cfoutput>
</title>
<cf_templatecss>
<cf_web_portlet_start titulo="#LB_CopiaValoresOf#">

<cfif isdefined("form.BTNCOPIAR") and form.BTNCOPIAR eq "Copiar">
	
	<cfif isdefined("form.PCCDclaid") and form.PCCDclaid neq "">

		<cfset LvarPCCEclaid = Form.PCCEclaid>
		<cfset LvarPCCDclaid = Form.PCCDclaid>

		<cfset PERAUX = Form.PERAUX>
		<cfset MESAUX = Form.MESAUX>

		<cfquery name="rsUENS" datasource="#session.dsn#">
		Select (PCCDvalor + '-' + PCCDdescripcion) as UEN
		from  PCClasificacionD	
		where PCCEclaid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPCCEclaid#"/> 
		  and PCCDclaid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPCCDclaid#"/>  
		</cfquery>
		<cfset LvarUEN = rsUENS.UEN>


		<cfset hayerrores=0>
		<cfset LvarMsgError = "">
		<cfset LvarMsgCop = "">
		
		<!--- VERIFICA SI HAY OFICINAS DEFINIDAS --->
		<cfquery name="VerDatos" datasource="#session.dsn#">
			Select count(1) as haydatos
			from OficinasxClasificacion
			where CGCperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CGCperiodo#"> 
			  and CGCmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CGCmes#">
			  and PCCDclaid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPCCDclaid#">
		</cfquery>
		
		<cfif VerDatos.haydatos gt 0>
			
			<cfquery name="rsInsNuevos" datasource="#session.dsn#">
				Select	count(1) as TotalNuevos
				from OficinasxClasificacion a
				where a.PCCDclaid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPCCDclaid#">
				  and a.CGCperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CGCperiodo#">
				  and a.CGCmes 	 = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CGCmes#">				
				  and not exists (Select 1
		  				  from OficinasxClasificacion b
						  where b.Ocodigo = a.Ocodigo
						    and coalesce(b.PCDcatid,-1) = coalesce(a.PCDcatid,-1)
						    and coalesce(b.PCCDclaid,-1)  = coalesce(a.PCCDclaid,-1)
						    and b.CGCperiodo = <cfqueryparam value="#PERAUX#" cfsqltype="cf_sql_integer">
						    and b.CGCmes     = <cfqueryparam value="#MESAUX#" cfsqltype="cf_sql_integer">)
			</cfquery>				
			<cfset LvarTotalnuevos = rsInsNuevos.TotalNuevos>
			<cfset LvarTotalviejos = 0>			
			
			<!--- INSERTA EN EL PERIODO-MES ACTUAL TODO LO QUE VIENE DEL ORIGEN QUE NO EXISTE --->
			<cfquery name="rstemp" datasource="#session.dsn#">
				insert into OficinasxClasificacion (	PCCDclaid, 
									PCDcatid, 
									CGCperiodo, 
									CGCmes, 
									Ocodigo, 
									CGCporcentaje)
					
				Select		a.PCCDclaid,
						a.PCDcatid,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#form.PERAUX#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#form.MESAUX#">,
						a.Ocodigo,
						a.CGCporcentaje
				from OficinasxClasificacion a
				where a.PCCDclaid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPCCDclaid#">
				  and a.CGCperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CGCperiodo#">
				  and a.CGCmes 	 = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CGCmes#">				
				  and not exists (Select 1
		  				  from OficinasxClasificacion b
						  where b.Ocodigo = a.Ocodigo
						    and coalesce(b.PCDcatid,-1) = coalesce(a.PCDcatid,-1)
						    and coalesce(b.PCCDclaid,-1)  = coalesce(a.PCCDclaid,-1)
						    and b.CGCperiodo = <cfqueryparam value="#PERAUX#" cfsqltype="cf_sql_integer">
						    and b.CGCmes     = <cfqueryparam value="#MESAUX#" cfsqltype="cf_sql_integer">)
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
					Delete from OficinasxClasificacion 
					where PCCDclaid	 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPCCDclaid#">
					  and CGCperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.PERAUX#">
					  and CGCmes 	 = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.MESAUX#">				
					  and exists(	Select 1
							from OficinasxClasificacion b
							where b.Ocodigo	   = OficinasxClasificacion.Ocodigo
							  and b.CGCperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CGCperiodo#">
							  and b.CGCmes	   = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CGCmes#">
							  and coalesce(b.PCDcatid,-1)   = coalesce(OficinasxClasificacion.PCDcatid,-1)
							  and coalesce(b.PCCDclaid,-1)  = coalesce(OficinasxClasificacion.PCCDclaid,-1)) 
				</cfquery>
					
				<cfquery name="rsInsViejos" datasource="#session.dsn#">
					Select	count(1) as TotalViejos
					from OficinasxClasificacion a
					where a.PCCDclaid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPCCDclaid#">
					  and a.CGCperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CGCperiodo#">
					  and a.CGCmes 	   = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CGCmes#">				
					  and not exists (Select 1
							  from CGParamConductores b
							  where b.Ocodigo = a.Ocodigo
							    and coalesce(b.PCDcatid,-1)  = coalesce(a.PCDcatid,-1)
							    and coalesce(b.PCCDclaid,-1) = coalesce(a.PCCDclaid,-1)
							    and b.CGCperiodo = <cfqueryparam value="#PERAUX#" cfsqltype="cf_sql_integer">
							    and b.CGCmes     = <cfqueryparam value="#MESAUX#" cfsqltype="cf_sql_integer">)
				</cfquery>							
				<cfset LvarTotalviejos = rsInsViejos.TotalViejos>					
					
				<cfquery name="rstemp" datasource="#session.dsn#">
					insert into OficinasxClasificacion (	PCCDclaid, 
										PCDcatid, 
										CGCperiodo, 
										CGCmes, 
										Ocodigo, 
										CGCporcentaje)
						
					Select	a.PCCDclaid,
						a.PCDcatid,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#form.PERAUX#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#form.MESAUX#">,
						a.Ocodigo,
						a.CGCporcentaje
					from OficinasxClasificacion a
					where a.PCCDclaid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPCCDclaid#">
					  and a.CGCperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CGCperiodo#">
					  and a.CGCmes 	   = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CGCmes#">				
					  and not exists (Select 1
							  from OficinasxClasificacion b
							  where b.Ocodigo = a.Ocodigo
							    and coalesce(b.PCDcatid,-1)  = coalesce(a.PCDcatid,-1)
							    and coalesce(b.PCCDclaid,-1) = coalesce(a.PCCDclaid,-1)
							    and b.CGCperiodo = <cfqueryparam value="#PERAUX#" cfsqltype="cf_sql_integer">
							    and b.CGCmes  = <cfqueryparam value="#MESAUX#" cfsqltype="cf_sql_integer">)
				</cfquery>
					
			</cfif>	

			<cfoutput>
			<cfset LvarMsgCop = LvarMsgCop & "<br>" & "Se copiaron " & #LvarTotalnuevos# & " oficinas para la UEN (" & #LvarUEN# & ") y se sobreescribieron " & #LvarTotalviejos# & " registros">
			</cfoutput>
				
		<cfelse>
			<cfset hayerrores=1>
			<cfoutput>
			<cfset LvarMsgError = LvarMsgError & "<br>" & "No hay oficinas definidas para la uen (" & #LvarUEN# & ") para el periodo-mes (" & #form.CGCperiodo# & "-" & #form.CGCmes# & ")">
			</cfoutput>
		</cfif>
		
		
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
		</cfif>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td align="center">
				<input type="button" name="btnReg" value="Regresar" onClick="javascript:history.back();">
				<input type="button" name="btnReg" value="Cerrar" onClick="javascript:window.close();window.opener.location.reload();">				
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>

		</table>		
		
	</cfif>

<cfelse>
	<center>Se presentaron errores con los parámetros requeridos para realizar la copia</center>
</cfif>
<cf_web_portlet_end>
