<!--- EJB --->
<cfset EjbUser = 'guest'>
<cfset EjbPass = 'guest'>
<cfset EjbJndi = 'SdcSeguridad/Afiliacion'>

<cfif isdefined("url.METEid") and len(trim(url.METEid)) gt 0 and not isdefined("form.METEid")>
	<cfset form.METEid = url.METEid>
</cfif>
<!--- Prende y apaga el debug.
		+ Si está prendido devuelve las acciones realizadas y no se devuelve a la pantalla.
--->
<cfset debug = false> <!--- General --->
<cfset debug2 = false> <!--- Para ver parámetros de Pila --->

<cfif debug>
	<cfdump var="#form#">
</cfif>
<!--- Realiza las acciones necesarias en la BD. --->
  <cftransaction>
  	<cfif (isdefined("Form.MEEimagen") and len(trim(Form.MEEimagen)) gt 0) or (isdefined("Form.Pfoto") and len(trim(Form.Pfoto)) gt 0)>
		<cftry>
			<!--- Copia la imagen a un folder del servidor servidor --->
			<cfif (isdefined("Form.MEEimagen") and len(trim(Form.MEEimagen)) gt 0)>
				<cffile action="Upload" fileField="Form.MEEimagen"  destination="#gettempdirectory()#" nameConflict="Overwrite" accept="image/*"> 
			<cfelse>
				<cffile action="Upload" fileField="Form.Pfoto"  destination="#gettempdirectory()#" nameConflict="Overwrite" accept="image/*"> 
			</cfif>
			
			<cfset tmp = "" ><!--- comtenido binario de la imagen --->
			
			<!--- lee la imagen de la carpeta del servidor y la almacena en la variable tmp --->
			<cffile action="readbinary" file="#gettempdirectory()##cffile.ClientFileName#.#cffile.ClientFileExt#" variable="tmp" >
			
			<cffile action="delete" file="#gettempdirectory()##cffile.ClientFileName#.#cffile.ClientFileExt#" >
		 
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
	
			<cfcatch type="any">
				<cfset error = true >
			</cfcatch> 
	
		</cftry>
	</cfif>
	
	<cffunction access="private" name="hayCaracteristicas" output="false" returntype="boolean">
		<cfargument name="METEid" required="yes" type="numeric">
		<cfargument default="0" name="n" required="no" type="numeric"><!--- corresponde al CurrentRow de Relaciones en el pintado de la lista --->
		<cfargument default="0" name="m" required="no" type="numeric"><!--- corresponde al indice de la fila en el pintado de la lista --->
		<cfset sn = iif(n gt 0,DE('_'&n),DE(''))>
		<cfset sm = iif(m gt 0,DE('_'&m),DE(''))>
		<cfset cont = 0>
		<cfquery name="rsCaracteristicas" datasource="#Session.DSN#">
			select convert(varchar,METECid) as METECid
			from METECaracteristica
			where METEid = #Arguments.METEid#
			and METEClista = 1
		</cfquery>
		<cfloop query="rsCaracteristicas">
			<cfoutput>Form.METEC_#rsCaracteristicas.METECid##sn##sm#:</cfoutput>&nbsp;
			<cfif isdefined("Form.METEC_"&rsCaracteristicas.METECid&sn&sm) and
			 len(trim(Evaluate("Form.METEC_"&rsCaracteristicas.METECid&sn&sm))) gt 0 and 
			 Evaluate("Form.METEC_"&rsCaracteristicas.METECid&sn&sm) neq 0>
				<cfset cont = cont + 1>
			</cfif>
		</cfloop>
		<cfreturn cont gt 0>
	</cffunction>

	<cffunction access="private" name="putCaracteristicas" output="true">
		<cfargument name="MEEid" required="yes" type="numeric">
		<cfargument name="METEid" required="yes" type="numeric">
		<cfargument default="0" name="n" required="no" type="numeric"><!--- corresponde al CurrentRow de Relaciones en el pintado de la lista --->
		<cfargument default="0" name="m" required="no" type="numeric"><!--- corresponde al indice de la fila en el pintado de la lista --->
		<cfset sn = iif(n gt 0,DE('_'&n),DE(''))>
		<cfset sm = iif(m gt 0,DE('_'&m),DE(''))>
		<cfset nombre = "">
		<cfset aux = "">
		<cfquery name="rsCaracteristicas" datasource="#Session.DSN#">
			select convert(varchar,METEid) as METEid,
				convert(varchar,METECid) as METECid,
				METECdescripcion,
				METECcantidad,
				METECvalor,
				METECfecha,
				METECtexto,
				METECbit,
				METECdesplegar,
				METEClista,
				METECrequerido,
				METEfila, 
				METEcol,
				METEorden
			from METECaracteristica
			where METEid = #Arguments.METEid#
			order by METEorden
		</cfquery>

		<cfloop query="rsCaracteristicas">

			<cfquery name="rsExiste" datasource="#Session.DSN#">
				select MECEcantidad, MECEvalor, MECEtexto, convert(varchar,MECEfecha,103) as MECEfecha, MECEbit, MEVCid
				from MECaracteristicaEntidad 
				where MEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.MEEid#">
				and METECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCaracteristicas.METECid#">
				and getdate() between MECEfechaini and MECEfechafin
			</cfquery>
			
			<cfset actualizo = 0>
			<cfset porque = "">
			<cfif isdefined("Form.METEC_"&rsCaracteristicas.METECid&sn&sm) and
			 len(trim(Evaluate("Form.METEC_"&rsCaracteristicas.METECid&sn&sm))) gt 0>
				<cfset valor = Evaluate("Form.METEC_"&rsCaracteristicas.METECid&sn&sm)>
				<cfset cambioCaracteristica = false>
				<cfif rsCaracteristicas.METECcantidad>
					<cfif rsExiste.MECEcantidad neq valor>
						<cfset cambioCaracteristica = true>
						<cfset porque = "Cantidad : valor = " & valor & " y rsExiste.MECEcantidad = " & rsExiste.MECEcantidad>
					</cfif>
				<cfelseif rsCaracteristicas.METECvalor>
					<cfif rsExiste.MECEvalor neq valor>
						<cfset cambioCaracteristica = true>
						<cfset porque = "Valor : valor = " & valor & " y rsExiste.MECEvalor = " & rsExiste.MECEvalor>
					</cfif>
				<cfelseif rsCaracteristicas.METECtexto>
					<cfif rsExiste.MECEtexto neq valor>
						<cfset cambioCaracteristica = true>
						<cfset porque = "Texto : valor = " & valor & " y rsExiste.MECEtexto = " & rsExiste.MECEtexto>
					</cfif>
				<cfelseif rsCaracteristicas.METECfecha>
					<cfif rsExiste.MECEfecha neq valor>
						<cfset cambioCaracteristica = true>
						<cfset porque = "Fecha : valor = " & valor & " y rsExiste.MECEfecha = " & rsExiste.MECEfecha>
					</cfif>
				<cfelseif rsCaracteristicas.METECbit>
					<cfif len(trim(rsExiste.MECEbit)) and not rsExiste.MECEbit>
						<cfset cambioCaracteristica = true>
						<cfset porque = "Bit : valor = " & valor & " y rsExiste.MECEbit = " & rsExiste.MECEbit>
					</cfif>
				<cfelseif rsExiste.MEVCid neq valor>
					<cfset cambioCaracteristica = true>
					<cfset porque = "MEVCid : valor = " & valor & " y rsExiste.MEVCid = " & rsExiste.MEVCid>
				</cfif>
				<cfif rsExiste.RecordCount gt 0 and cambioCaracteristica>
					<cfquery name="DEF_Guardar" datasource="#Session.DSN#">
						Update MECaracteristicaEntidad 
						set MECEfechafin = getdate()
						where MEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.MEEid#">
						and METECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCaracteristicas.METECid#">
						and getdate() between MECEfechaini and MECEfechafin
					</cfquery>
					<cfset actualizo = 1>
				</cfif>
				<cfif rsExiste.RecordCount eq 0 or cambioCaracteristica>
					<cfquery name="DEF_Guardar" datasource="#Session.DSN#">						
						insert MECaracteristicaEntidad 
							(MEEid, METECid, MECEcantidad, MECEvalor, MECEtexto, MECEfecha, MECEbit, MEVCid, 
							MECEfechaini, MECEfechafin, MECEfechareg, Usucodigo, Usulocalizacion, MECEanulada)
						values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.MEEid#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCaracteristicas.METECid#">, 
							<cfif rsCaracteristicas.METECcantidad><cfqueryparam cfsqltype="cf_sql_money" value="#valor#"><cfelse>null</cfif>, 
							<cfif rsCaracteristicas.METECvalor><cfqueryparam cfsqltype="cf_sql_money" value="#valor#"><cfelse>null</cfif>, 
							<cfif rsCaracteristicas.METECtexto><cfqueryparam cfsqltype="cf_sql_varchar" value="#valor#"><cfelse>null</cfif>, 
							<cfif rsCaracteristicas.METECfecha>convert(datetime,<cfqueryparam cfsqltype="cf_sql_varchar" value="#valor#">,103)<cfelse>null</cfif>, 
							<cfif rsCaracteristicas.METECbit>1<cfelse>0</cfif>, 
							<cfif not (rsCaracteristicas.METECcantidad or rsCaracteristicas.METECvalor or rsCaracteristicas.METECtexto
										or rsCaracteristicas.METECfecha or rsCaracteristicas.METECbit)><cfqueryparam cfsqltype="cf_sql_numeric" value="#valor#"><cfelse>null</cfif>,
							getdate(), 
							'61000101', 
							getdate(), 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
							<cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">,
							0)
					</cfquery>
					<cfset actualizo = actualizo + 2>
				</cfif>
			</cfif>

			<cfif debug>
				<cfdump var="#rsExiste#" label="rsExiste">
				Actualizando Caracteristica <cfoutput>#rsCaracteristicas.METECid#</cfoutput>... Actualizo = <cfoutput>#actualizo#</cfoutput>.
				<cfswitch expression="#actualizo#">
				<cfcase value="0">
					No Cambió.
				</cfcase>
				<cfcase value="1">
					Actualizó.
				</cfcase>
				<cfcase value="2">
					Insertó.
				</cfcase>
				<cfcase value="3">
					Actualizó e Insertó.
				</cfcase>
				</cfswitch>
				porque <cfoutput>#porque#</cfoutput>
				<br>
			</cfif>
			
			<cfif len(trim(rsCaracteristicas.METEorden)) and rsCaracteristicas.METEorden neq 0>
				<cfset escogio = 0>
				<cfif isdefined("Form.METEC_"&rsCaracteristicas.METECid&sn&sm) and
				 len(trim(Evaluate("Form.METEC_"&rsCaracteristicas.METECid&sn&sm))) gt 0>
					<cfset nombre = nombre & aux & Evaluate("Form.METEC_"&rsCaracteristicas.METECid&sn&sm)>
					<cfset aux = " ">
					<cfset escogio = 1>
				<cfelseif rsExiste.RecordCount gt 0 and rsCaracteristicas.METECtexto>
					<cfset nombre = nombre & aux & rsExiste.MECEtexto>
					<cfset aux = " ">
					<cfset escogio = 2>
				</cfif>
				<cfif debug>
					Creando Nombre... METEorden = <cfoutput>#rsCaracteristicas.METEorden#</cfoutput> >> Nombre = <cfoutput>#nombre#</cfoutput> >> Escogio = <cfoutput>#escogio#</cfoutput>.<br>
				</cfif>
			</cfif>
		</cfloop>
		<cfquery name="MNO_Guardar" datasource="#Session.DSN#">
			Update MEEntidad 
			set MEEnombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#nombre#">,
			MEEidentificacion = case when MEEidentificacion is null then convert(varchar,MEEid) when datalength(MEEidentificacion) = 0 then convert(varchar,MEEid) else MEEidentificacion end
			where MEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.MEEid#">
		</cfquery>
	</cffunction>


	<!--- 
	***********************************************************************************************************************************
	***********************************************************************************************************************************
	********************************************************INICIO*********************************************************************
	***********************************************************************************************************************************
	***********************************************************************************************************************************
	--->
		
		<!--- 
		********************************************************ENCABEZADO*********************************************************************
		--->
		
		<cfquery name="ABC_GUARDAR" datasource="#Session.DSN#">
		
			<cfif isdefined("Form.MEEid") and len(trim(Form.MEEid))>
				Update MEEntidad
				set <cfif isdefined("Form.MEEemail") and len(trim(Form.MEEemail))>MEEemail = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.MEEemail#">, </cfif>
					<cfif isdefined("Form.MEEidentificacion") and len(trim(Form.MEEidentificacion))>MEEidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.MEEidentificacion#">, </cfif>
					<cfif isdefined("ts") and len(trim(ts))>MEEimagen = #ts#, </cfif>
					<cfif isdefined("Form.MEEdescripcion") and len(trim(Form.MEEdescripcion))>MEEdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.MEEdescripcion#">, </cfif>
					MEEnombre = ''
				where MEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.MEEid#">
				select <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.MEEid#"> as MEEid, 0 as CrearUsuario
			<cfelse>
				insert MEEntidad 
					(METEid, cliente_empresarial, Ecodigo, MEEnombre, MEEemail, MEEidentificacion, MEEimagen, 
					MEEdescripcion, MEEfechaini, MEEfechafin, Usucodigo, Ulocalizacion, MEPEanulada)
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.METEid#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
					'', 
					<cfif isdefined("Form.MEEemail") and len(trim(Form.MEEemail))><cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.MEEemail#"><cfelse>null</cfif>, 
					<cfif isdefined("Form.MEEidentificacion") and len(trim(Form.MEEidentificacion))><cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.MEEidentificacion#"><cfelse>null</cfif>, 
					<cfif isdefined("ts") and len(trim(ts))>#ts#<cfelse>null</cfif>,
					<cfif isdefined("Form.MEEdescripcion") and len(trim(Form.MEEdescripcion))><cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.MEEdescripcion#"><cfelse>null</cfif>, 
					convert(varchar,getdate(), 112),
					'61000101', 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">, 
					0
				)
				select @@identity as MEEid, 1 as CrearUsuario
			</cfif>
		</cfquery>

		<!--- Guardar Carcterísticas de la Entidad --->
		
		<cfset putCaracteristicas(ABC_GUARDAR.MEEid,Form.METEid)>
		
		<cfset FormArrayEmpresa = ListToArray(form.Empresa, '|')>
		
		<!--- Crea Usuario inserta en Tablas: Usuario, UasuarioEmpresarial, UsuarioEmpresa, y UsuarioPermiso --->
		<cfif IsDefined("session.Usucodigo") and session.Usucodigo NEQ 0>
			<!--- Pasarlo de Empresa --->
			<!--- Darle el rol --->
			<cfinvoke 
			 component="sif.rh.Componentes.usuarios"
			 method="add_rol"
			 returnvariable="UsrInserted">
				<cfinvokeargument name="cliente_empresarial" value="#Session.sitio.cliente_empresarial#"/>
				<cfinvokeargument name="Ecodigo" value="#FormArrayEmpresa[1]#"/>
				<cfinvokeargument name="Usucodigo" value="#Session.Usucodigo#"/>
				<cfinvokeargument name="Ulocalizacion" value="#Session.Ulocalizacion#"/>
				<cfinvokeargument name="referencias" value="#ABC_GUARDAR.MEEid#"/>
				<cfinvokeargument name="roles" value="me.afiliado"/>
				<cfinvokeargument name="activacion" value="1"/>
			</cfinvoke>
		</cfif>
		<!--- Actualización de datos del Usuario en el Framework --->
		<cfinvoke 
		 component="sif.rh.Componentes.usuarios"
		 method="upd_usuario"
		 returnvariable="UsrInserted">
			<cfinvokeargument name="consecutivo" value="#FormArrayEmpresa[2]#"/>
			<cfinvokeargument name="sistema" value="me"/>
			<cfinvokeargument name="referencias" value="#ABC_GUARDAR.MEEid#"/>
			<cfinvokeargument name="roles" value="me.afiliado"/>
			<cfinvokeargument name="activacion" value="1"/>
			<cfinvokeargument name="Pnombre" value="#form.Pnombre#"/>
			<cfinvokeargument name="Papellido1" value="#form.Papellido1#"/>
			<cfinvokeargument name="Papellido2" value="#form.Papellido2#"/>
			<cfinvokeargument name="Ppais" value="#form.Ppais#"/>
			<cfinvokeargument name="TIcodigo" value="#form.TIcodigo#"/>
			<cfinvokeargument name="Pid" value="#form.Pid#"/>
			<cfinvokeargument name="Pnacimiento" value="#form.Pnacimiento#" />
			<cfinvokeargument name="Psexo" value="#form.Psexo#"/>
			<cfinvokeargument name="Pemail1" value="#form.Pemail1#"/>
			<cfinvokeargument name="Pemail2" value="#form.Pemail2#"/>
			<cfinvokeargument name="Pdireccion" value="#form.Pdireccion#"/>
			<cfinvokeargument name="Pcasa" value="#form.Pcasa#"/>
			<cfinvokeargument name="Poficina" value="#form.Poficina#"/>
			<cfinvokeargument name="Pcelular" value="#form.Pcelular#"/>
			<cfinvokeargument name="Pfax" value="#form.Pfax#"/>
			<cfinvokeargument name="Ppagertel" value="#form.Ppagertel#"/>
			<cfinvokeargument name="Ppagernum" value="#form.Ppagernum#"/>
			<cfif isdefined("ts") and len(trim(ts))>
				<cfinvokeargument name="Pfoto" value="#ts#"/>
			</cfif>
			
			<cfinvokeargument name="Icodigo" value="#form.Icodigo#" ><!--- Idioma --->
			<cfinvokeargument name="Pweb" value="#form.Pweb#" ><!--- web page --->
			<cfinvokeargument name="Pciudad" value="#form.Pciudad#" ><!--- ciudad --->
			<cfinvokeargument name="Pprovincia" value="#form.Pprovincia#" ><!--- provincia --->
			<cfinvokeargument name="PcodPostal" value="#form.PcodPostal#" ><!--- codigo postal --->

			<cfinvokeargument name="modificar_usuario_activo" value="yes"/>
		</cfinvoke>
		
		<cfquery datasource="#session.dsn#">
			Update MEEntidad 
			set MEEnombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pnombre# #form.Papellido1# #form.Papellido2#">,
			MEEidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pid#">
			where MEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ABC_GUARDAR.MEEid#">
		</cfquery>
		<cfif ABC_GUARDAR.CrearUsuario>
			<!--- LLAMAR AL EJB PARA QUE ENVIE EL CORREO --->
			<cfscript>
				function getAfiliacionEJB ( )
				{
					var home = 0;
					var prop = 0;
			
					if (IsDefined ("__AfiliacionStub")) {
						return __AfiliacionStub;
					}
			
					// initial context
					prop = CreateObject("java", "java.util.Properties" );
					initContext = CreateObject("java", "javax.naming.InitialContext" );
					// especificar propiedades, esto se requiere para objetos remotos
					prop.init();
					prop.put(initContext.SECURITY_PRINCIPAL, EjbUser);
					prop.put(initContext.SECURITY_CREDENTIALS, EjbPass);
					initContext.init(prop);
					
					// ejb lookup
					home = initContext.lookup(EjbJndi);
					
					// global var, reuse
					__AfiliacionStub = home.create();
					return __AfiliacionStub;
				}
			</cfscript>
			<!---
			no esta sirviendo, y de todos modos se manda automatico por un task
			<cfset getAfiliacionEJB().prepararUsuarioTemporal(UsrInserted.Usucodigo,UsrInserted.Ulocalizacion,true)>
			--->
		</cfif>
		<cfif debug>
			<cfdump var="#session#" label="S E S S I O N">
			<cfabort>
		</cfif>
  </cftransaction>

<cfif ABC_GUARDAR.CrearUsuario>
	<cflocation url="%7Emi-cuenta-gracias.cfm">
<cfelse>
	<cflocation url="%7Emi-cuenta-listo.cfm">
</cfif>
