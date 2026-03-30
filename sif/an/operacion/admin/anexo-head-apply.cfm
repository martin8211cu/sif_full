<cfset Request.ya_existia = Len(form.AnexoId)>

<cfset copia_anexo_check = 0>
<cfif isdefined("form.copia_anexo_check")>
	<cfset copia_anexo_check = 1>
</cfif>

<!---<cf_dump var="#form#">
---><cftransaction>
	<cfif not Request.ya_existia>
		<cfquery datasource="#session.dsn#" name="nuevo">
			insert into Anexo 
				(CEcodigo, Ecodigo, GAid, AnexoDes, 
				 AnexoFec, AnexoUsu, AnexoSeq, 
				 AnexoOcultaFilas, 
				 AnexoOcultaColumnas, 
				 AnexoSaldoConvertido,
				 BMUsucodigo)
			values (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">,
				 #session.Ecodigo# ,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GAid#" null="#Len(form.GAid) EQ 0#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.AnexoDes#">,
				
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.AnexoSeq#">,
				<cfif isdefined("form.chkOcultarFilas")>1<cfelse>0</cfif>, 
				<cfif isdefined("form.chkOcultarColumnas")>1<cfelse>0</cfif>, 
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.cboSaldosConvertidos#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			)
			<cf_dbidentity1>
		</cfquery>
		<cf_dbidentity2 name="nuevo">
		<cfset form.AnexoId = nuevo.identity>
		
		<cfquery datasource="#session.dsn#">
			insert into AnexoPermisoDef(Ecodigo, Usucodigo, APnombre,APemail, GAid, AnexoId, APver, APedit, APcalc, APdist, APrecip,BMfecha,BMUsucodigo)
			values(	 #session.Ecodigo# ,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.datos_personales.nombre# #session.datos_personales.apellido1# #session.datos_personales.apellido2#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.datos_personales.email1#">,
					null,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AnexoId#">,
					1, 1, 1, 1, 1,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#"> )
		</cfquery>
		<cfquery name="insert" datasource="#Session.DSN#">
			insert into AnexoEm(Ecodigo, AnexoId, BMUsucodigo)
			values(	 #session.Ecodigo# ,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AnexoId#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#"> )
		</cfquery>
		
		<!---Inicio - Duplicar un Anexo--->
		<cfif copia_anexo_check EQ 1>
			<cfif form.Copiar_Anexo_ID NEQ 0>
				<!---Selecciona Celdas para Copiarlas en nuevo Anexo--->
				<cfquery datasource="#session.dsn#" name="AnexoCopia">
					select * from AnexoCel where AnexoId = #form.Copiar_Anexo_ID# order by AnexoCelId
				</cfquery>
	
				<cfloop query="AnexoCopia">
				
					<cfset AnxID = AnexoCopia.AnexoCelId>
				
					<!---Inserta Celdas en nuevo Anexo--->
					<cfquery datasource="#session.dsn#" name="AnexoCopiaCeldas">
						insert into AnexoCel (AnexoId, AnexoHoja, AnexoRan, AnexoCon, Ecodigo, AVid,     
						AnexoES, AnexoRel, AnexoMes, AnexoPer, Ocodigo, AnexoNeg, 
						BMUsucodigo, AnexoFila, AnexoColumna, Ecodigocel, GOid, GEid, AnexoFor)
						values( 
						
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AnexoId#">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#AnexoCopia.AnexoHoja#">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#AnexoCopia.AnexoRan#">,
						<cfif len(Trim(AnexoCopia.AnexoCon)) eq 0>
							null,
						<cfelse>
							<cfqueryparam cfsqltype="cf_sql_integer" value="#AnexoCopia.AnexoCon#">,
						</cfif>
						 #session.Ecodigo# ,
						<cfif len(Trim(AnexoCopia.AVid)) eq 0>	
							null,
						<cfelse>						
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#AnexoCopia.AVid#">,					
						</cfif>
	
						<cfqueryparam cfsqltype="cf_sql_char" value="#AnexoCopia.AnexoES#">,
						
						<cfqueryparam cfsqltype="cf_sql_integer" value="#AnexoCopia.AnexoRel#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#AnexoCopia.AnexoMes#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#AnexoCopia.AnexoPer#">,
						<cfif len(Trim(AnexoCopia.Ocodigo)) eq 0>
							null,
						<cfelse>					
							<cfqueryparam cfsqltype="cf_sql_integer" value="#AnexoCopia.Ocodigo#">,
						</cfif>
						<cfif len(Trim(AnexoCopia.AnexoNeg)) eq 0>
							null,
						<cfelse>					
							<cfqueryparam cfsqltype="cf_sql_integer" value="#AnexoCopia.AnexoNeg#">,
						</cfif>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#AnexoCopia.AnexoFila#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#AnexoCopia.AnexoColumna#">,
						
						<cfif len(Trim(AnexoCopia.Ecodigocel)) eq 0>
							null,
						<cfelse>					
							<cfqueryparam cfsqltype="cf_sql_integer" value="#AnexoCopia.Ecodigocel#">,
						</cfif>
						
						<cfif len(Trim(AnexoCopia.GOid)) eq 0>
							null,
						<cfelse>					
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#AnexoCopia.GOid#">,
						</cfif>	
						
						<cfif len(Trim(AnexoCopia.GEid)) eq 0>			
							null,
						<cfelse>					
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#AnexoCopia.GEid#">,					
						</cfif>
						
						<cfif len(Trim(AnexoCopia.AnexoFor)) eq 0>	
							null
						<cfelse>					
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#AnexoCopia.AnexoFor#">
						</cfif>	)
						<cf_dbidentity1>
					</cfquery>
					<cf_dbidentity2 name="AnexoCopiaCeldas">
					<cfset form.AnexoCelId = AnexoCopiaCeldas.identity>
	
					<!---Selecciona Descripciones de las Celdas para Copiarlas en nuevo Anexo--->
					<cfquery datasource="#session.dsn#" name="AnexoCeldasDescripcion">
						select * 
						from AnexoCelD 
						where AnexoCelId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#AnxID#">
					</cfquery>
					<cfloop query="AnexoCeldasDescripcion">
						<!---Inserta Descripciones de Celdas en nuevo Anexo--->
						<cfquery datasource="#session.dsn#" name="AnexoCopiaCeldasDescripcion">
							insert into AnexoCelD (AnexoCelId, Ecodigo, AnexoCelFmt, AnexoCelMov, AnexoSigno,
							BMUsucodigo, Anexolk, Cmayor, PCDcatid)
							values( 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AnexoCelId#">,
								 #session.Ecodigo# ,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#AnexoCeldasDescripcion.AnexoCelFmt#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#AnexoCeldasDescripcion.AnexoCelMov#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#AnexoCeldasDescripcion.AnexoSigno#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
								<cfif len(trim(AnexoCeldasDescripcion.Anexolk)) eq 0>
									null,
								<cfelse>
									<cfqueryparam cfsqltype="cf_sql_integer" value="#AnexoCeldasDescripcion.Anexolk#">,
								</cfif>
								
								<cfif len(trim(AnexoCeldasDescripcion.Cmayor)) eq 0>
									null,
								<cfelse>
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#AnexoCeldasDescripcion.Cmayor#">,
								</cfif>
								<cfif len(trim(AnexoCeldasDescripcion.PCDcatid)) eq 0>
									null
								<cfelse>
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#AnexoCeldasDescripcion.PCDcatid#">
								</cfif>
							)
						</cfquery>
						
						<cfquery datasource="#session.dsn#" name="AnexoCopiaConceptos">
							INSERT into AnexoCelConcepto(AnexoCelId,	Ecodigo, Cconcepto)
							Select 	<CF_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.AnexoCelId#">,
									 #session.Ecodigo# ,
									Cconcepto
							from AnexoCelConcepto
							where AnexoCelId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#AnxID#">
						</cfquery>
						
					</cfloop>
	
				</cfloop>
				<!---Inserta Anexoim de nuevo Anexo--->
					<cfquery datasource="#session.dsn#" name="AnexoCopiaim_Insert">
						insert into Anexoim (AnexoId, 
											Ecodigo, 
											AnexoDef, 
											AnexoEditor, 
											BMUsucodigo,
											AnexoXLS,
											AnexoZIP)
						Select  <CF_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.AnexoId#">,
								Ecodigo,
								AnexoDef,
								AnexoEditor,
								<CF_jdbcquery_param cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
								AnexoXLS,
								AnexoZIP							
						from Anexoim
						where AnexoId = <CF_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.Copiar_Anexo_ID#">
	
					</cfquery>
			</cfif>
		</cfif>
		<!---Final - Duplicar un Anexo--->
	</cfif>

	<cfif Len(form.excel)>
		<cfset accept = "text/xml,application/x-xml,application/xml">
	
		<!--- no uso el cf_dbupdate porque está hecho para BLOBs, y este es CLOB --->
		<cffile action="upload" filefield="form.excel" 
			destination="#gettempdirectory()#" nameConflict="overwrite" accept="#accept#">
		<cfset excel_xml = "" >
		<!--- lee la imagen de la carpeta del servidor y la almacena en la variable tmp --->			
		<cffile action="read" charset="utf-8" file="#gettempdirectory()##cffile.ClientFileName#.#cffile.ClientFileExt#" variable="Request.excel_xml" >
		<cffile action="delete" file="#gettempdirectory()##cffile.ClientFileName#.#cffile.ClientFileExt#" >

		<cfinvoke component="sif.an.operacion.admin.anexo-UpParseoXML" 
			method="GuardarAnexo"
			AnexoId = "#Form.AnexoId#"
			AnexoEditor = "I"  /><!--- I = importado --->
	</cfif>
	
	<cfif Request.ya_existia>
		<cfquery datasource="#session.dsn#">
			update Anexo
			set AnexoDes = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.AnexoDes#">,
				GAid     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GAid#" null="#Len(form.GAid) EQ 0#">,
				AnexoFec = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
				AnexoSeq = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.AnexoSeq#">,
				AnexoOcultaFilas = <cfif isdefined("form.chkOcultarFilas")>1<cfelse>0</cfif>, 
				AnexoOcultaColumnas = <cfif isdefined("form.chkOcultarColumnas")>1<cfelse>0</cfif>, 
				AnexoSaldoConvertido = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.cboSaldosConvertidos#">, 
				BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			where AnexoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AnexoId#">
		</cfquery>
	</cfif>

</cftransaction>

<cfset LvarPto1 = find("&tab=",cgi.HTTP_REFERER)>
<cfset LvarTab = "">
<cfif LvarPto1 GT 0>
	<cfset LvarTab = mid(cgi.HTTP_REFERER,LvarPto1,6)>
</cfif>
<cflocation url="anexo.cfm?AnexoId=#form.AnexoId##LvarTab#">
