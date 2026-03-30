<!---
	Modificado por: Rodolfo Jiménez Jara 24 de Junio 2005
	Motivo: Cambio del mantenimiento de la firma digital

	Modificado por Rebeca Corrales Alfaro 20 de Julio 2005
	Motivo: Incorporación de  mantenimiento a Usuarios Autorizados
--->
<!---ABG-Solucion temporal. Se debe validar por que a los objetos de Form CMCid y CMUid se les esta agregando una , en la form de compradores--->
<cfif isdefined("form.CMCid")>
	<cfset form.CMCid = replace(form.CMCid,",","")>
</cfif>
<cfif isdefined("form.CMUid")>
	<cfset form.CMUid = replace(form.CMUid,",","")>
</cfif>
<cfif isdefined ("form.AgregarUsuario") and isdefined ("form.Usucodigo") and len(trim(form.Usucodigo))>
	<cfquery name="insert" datasource="#session.DSN#">
		insert into CMUsuarioAutorizado (CMCid, Ecodigo, Usucodigo, BMUsucodigo, CMCCFfecha)
			values(
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMCid#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.UsucodigoAutor#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">)
	</cfquery>
<cfelseif isdefined ("form.CMUid") and len(trim(form.CMUid))>
	<cfquery name="delete" datasource="#session.DSN#">
		delete from CMUsuarioAutorizado
		where CMUid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMUid#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">

	</cfquery>

</cfif>





<cfif not isdefined("Form.Nuevo")>

		<cfif isdefined("form.BtnImagen") and len(trim(form.BtnImagen))>
			<cfquery name="deleteFirma" datasource="#Session.DSN#">
				delete from CMFirmaComprador
				where CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMCid#">
			</cfquery>

		<cfelseif isdefined("form.Alta")> <!--- CFIF DE BOTON ALTA --->
			<cfquery name="rsValidaExiste" datasource="asp">
				select Usucodigo
				from UsuarioReferencia
				where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.EcodigoSDC#" >
				  and STabla='CMCompradores'
				  and Usucodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Usucodigo#" >
			</cfquery>

			<cfif rsValidaExiste.recordCount gt 0>
				<cf_errorCode	code = "50254" msg = "El registro que desea insertar o modificar, ya existe.">
			</cfif>
		</cfif>

		<!--- Componente de Seguridad --->
		<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">

		<cfset existe = false>
		<cfset existeDefault = false>
		<cfset tieneSubordinados = false>
		<cfset puedeSerJefe = true>
		<cfset tieneSolicitudes = false>

		<cfif not isdefined("form.Alta")> <!--- CFIF DE BOTON ALTA --->
			<cfquery name="rsExiste" datasource="asp">
				select Usucodigo
				from UsuarioReferencia
				where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.EcodigoSDC#" >
				  and STabla='CMCompradores'
				  and Usucodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Usucodigo#" >
			</cfquery>

			<cfif isdefined("rsExiste") and rsExiste.recordCount GT 0>
				<cfset valorExiste = 1>
			<cfelse>
				<cfset valorExiste = 0>
			</cfif>

			<cfif valorExiste EQ 1 and isdefined("Form.Alta")>
				<cfset existe = true>
				<script>
					alert("El comprador ya existe");
				</script>
			</cfif>

			<cfquery name="rsExisteDefault" datasource="#Session.DSN#">
				select 1 from CMCompradores
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and CMCdefault = 1
					<cfif isDefined("Form.CMCid") and Len(Trim(Form.CMCid)) GT 0 and not isDefined("Form.Nuevo") >
						and CMCid != <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.CMCid#">
					</cfif>
			</cfquery>

			<cfif isdefined("rsExisteDefault") and rsExisteDefault.recordCount GT 0>
				<cfset valorExisteDefault = 1>
			<cfelse>
				<cfset valorExisteDefault = 0>
			</cfif>

			<cfif valorExisteDefault EQ 1 and (isdefined("Form.Alta") or isdefined("Form.Cambio"))>
				<cfset existeDefault = true>
				<!---
				<script>
					alert("El comprador default ya existe");
				</script>
				--->
			</cfif>

			<cfif valorExiste EQ 1 >
				<cfquery name="rsTieneSubordinados" datasource="#Session.DSN#">
					select 1 from CMCompradores
					where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
						and CMCjefe = <cfqueryparam value="#Form.Usucodigo#" cfsqltype="cf_sql_numeric">
						and Usucodigo != CMCjefe
				</cfquery>

				<cfif isdefined("rsTieneSubordinados") and rsTieneSubordinados.recordCount GT 0>
					<cfset valorSubordinados = 1>
				<cfelse>
					<cfset valorSubordinados = 0>
				</cfif>

				<!--- Valida que existan solicitudes pendientes o posteadas para validar el borrado de compradores --->
				<cfquery name="rsTieneSolicitudesPosteadas" datasource="#Session.DSN#">
					select 1 from DSolicitudCompraCM
					where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
						and CMCid = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.CMCid#">
				</cfquery>

				<cfif isdefined("rsTieneSolicitudesPosteadas") and rsTieneSolicitudesPosteadas.recordCount GT 0>
					<cfset valorSolicitudesPosteadas = 1>
				<cfelse>
					<cfset valorSolicitudesPosteadas = 0>
				</cfif>

				<cfif valorSubordinados EQ 1 and isdefined("Form.Baja")>
					<cfset tieneSubordinados = true>
					<script>
						alert("El comprador no se puede eliminar debido a que tiene subordinados");
					</script>
				<cfelseif valorSolicitudesPosteadas EQ 1 and isdefined("Form.Baja")>
					<cfset tieneSolicitudes = true>
					<script>
						alert("El comprador no se puede eliminar debido a que tiene solicitudes asignadas");
					</script>
				</cfif>
			</cfif>
			<!--- Fin del <cfif valorExiste EQ 1 > --->
		</cfif><!--- CFIF DE BOTON ALTA --->

		<cfif isdefined("Form.Cambio")>
			<cfset Usucodigo = 0>
			<cfset CMCid = Form.CMCid>		<!--- Id del usuario a cambiarle su jefe --->
			<cfset NuevoJefe = 0>			<!--- Usucodigo del posible jefe del usuario --->
			<cfset Jefe = 0>

			<cfif len(trim(Form.CMCjefe)) GT 0>
				<cfset NuevoJefe = Form.CMCjefe>
			</cfif>
			<cfset NuevoJefeInicial = NuevoJefe>

			<!--- Usucodigo del Usuario --->
			<cfquery name="rsPuedeSerJefe" datasource="#Session.DSN#">
				select Usucodigo from CMCompradores
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and CMCid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CMCid#">
			</cfquery>
			<cfset 	Usucodigo  = rsPuedeSerJefe.Usucodigo >

			<cfif isdefined("rsPuedeSerJefe") and rsPuedeSerJefe.recordCount GT 0>
				<cfloop condition="1 EQ 1">
					<cfquery name="rsJefe" datasource="#Session.DSN#">
						select CMCjefe, CMCnombre
						from CMCompradores
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and Usucodigo = #NuevoJefe#
					</cfquery>

					<cfif len(trim(rsJefe.CMCjefe)) and rsJefe.CMCjefe EQ Usucodigo>
						<cfset valor = 0>
						<cfbreak>
					</cfif>

					<cfif len(trim(rsJefe.CMCjefe)) EQ 0 or rsJefe.CMCjefe EQ NuevoJefeInicial>
						<cfset valor = 1>
						<cfbreak>
					</cfif>
					<cfset NuevoJefe = rsJefe.CMCjefe>
				</cfloop>
			</cfif>

			<cfif valor EQ 0 >
				<cfset puedeSerJefe = false>
				<script>
					alert("El jefe no se puede asignar debido a que éste, es subordinado de este comprador");
				</script>
			</cfif>
		</cfif>
		<!--- Fin del <cfif isdefined("Form.Cambio")> --->

		<cfif isdefined("Form.Alta")>
			<cfif not existe>
				<!--- quita el bit de comprador default --->
				<cfif existeDefault and isdefined("Form.CMCdefault")>
					<cfquery name="updateAltaDefault" datasource="#Session.DSN#">
						update CMCompradores
						set CMCdefault = 0
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					</cfquery>
				</cfif>
				<!--- Valida que el CMCcodigo no exista --->
				<cfquery name="valida" datasource="#session.DSN#">
					select 1 from CMCompradores
					where Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					  and CMCcodigo      = <cfqueryparam cfsqltype="cf_sql_char" value="#form.CMCcodigo#">
				</cfquery>
				<cfif valida.RecordCount gt 0>
					<cf_errorCode	code = "50255" msg = "El Código del Comprador ya existe, por favor intente de nuevo.">
				</cfif>

				<cftransaction>
					<cfquery name="insert" datasource="#Session.DSN#">
						insert into CMCompradores (Ecodigo, DEid, CMCnombre, CMCjefe, CMCdefault, CMCestado, Usucodigo, CMCfecha, CMCnivel, CMTStarticulo, CMTSservicio, CMTSactivofijo, CMTSobra,
												 CMCcodigo, Mcodigo, CMCmontomax, CMCautorizador, CMCparticipa )
							values (<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
									<cfif isdefined("form.DEid") and len(trim(form.DEid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#"><cfelse>null</cfif>,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.Nombre)#">,
									<cfif isdefined("Form.CMCjefe") and Len(Trim(Form.CMCjefe)) GT 0 ><cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMCjefe#"><cfelseif isdefined("Form.CMCjefeid") and Len(Trim(Form.CMCjefeid)) GT 0 ><cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.UsucodigoJefe#"><cfelse>null</cfif>,
									<cfif isdefined("Form.CMCdefault")>1<cfelse>0</cfif>,
									<cfif isdefined("Form.CMCestado")>1<cfelse>0</cfif>,
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Usucodigo#">,
									<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
									<cfif isdefined("Form.CMCjefe") and Len(Trim(Form.CMCjefe)) GT 0 and Compare(Trim(Form.CMCjefe),Trim(Form.Usucodigo)) EQ 0>0<cfelseif isdefined("Form.CMCjefeid") and Len(Trim(Form.CMCjefeid)) GT 0 ><cfqueryparam cfsqltype="cf_sql_numeric" value="#IncrementValue(Form.CMCnivelJefe)#"><cfelse>0</cfif>,
									<cfif isdefined("Form.CMTSarticulo")>1<cfelse>0</cfif>,
									<cfif isdefined("Form.CMTSservicio")>1<cfelse>0</cfif>,
									<cfif isdefined("Form.CMTSactivofijo")>1<cfelse>0</cfif>,
									<cfif isdefined("Form.CMTSobra")>1<cfelse>0</cfif>,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.CMCcodigo)#">,
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#">,
									<cfqueryparam cfsqltype="cf_sql_money" value="#Form.CMCmontomax#">,
									<cfif isdefined("Form.CMCautorizador")>1<cfelse>0</cfif>,
									<cfif isdefined("Form.CMCparticipa")>1<cfelse>0</cfif> )
						<cf_dbidentity1 datasource="#session.DSN#">
					</cfquery>
					<cf_dbidentity2 datasource="#session.DSN#" name="insert">

					<!---
s						<!--- inserta la firma digital --->
						<cfif isdefined("form.CMFfirma") and len(trim(form.CMFfirma))>
							<cfquery name="insertFirma" datasource="#Session.DSN#">
								insert into CMFirmaComprador(CMCid, CMFfirma)
								values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#insert.identity#">,
										<cf_dbupload filefield="CMFfirma" accept="image/*" datasource="#session.DSN#">)
							</cfquery>
						</cfif>
					 --->
				</cftransaction>

				<!--- inserta referencia y rol --->
				<cfset sec.insUsuarioRef(form.Usucodigo,session.EcodigoSDC,'CMCompradores',insert.identity)>
				<!--- Parametro 870.--->
				<!--- Si el paramtros tiene valor definido, lo asigna al comprador
					  Si no existe el parametro o esta vacio, asigna el default SOLIC
				--->
				<cfquery name="rsRol" datasource="#session.DSN#">
					select Pvalor as rol
					from Parametros
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					  and Pcodigo = 870
				</cfquery>
				<cfif len(trim(rsRol.rol))>
					<cfset sec.insUsuarioRol(form.Usucodigo,session.EcodigoSDC,'SIF', trim(rsRol.rol) ) >
				<cfelse>
					<cfset sec.insUsuarioRol(form.Usucodigo,session.EcodigoSDC,'SIF','COMPRADOR')>
				</cfif>

			</cfif>
			<cfset modo="ALTA">

		<cfelseif isdefined("Form.Baja") and not tieneSubordinados and not tieneSolicitudes>
			<cfquery name="deleteFirma" datasource="#Session.DSN#">
				delete from CMFirmaComprador
				where CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMCid#">
			</cfquery>
			<cfquery name="deleteEspecializacion" datasource="#session.dsn#">
				delete from CMEspecializacionComprador
					where CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMCid#">
						and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>
			<cfquery name="delete" datasource="#Session.DSN#">
				delete from CMCompradores
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
					and CMCid = <cfqueryparam value="#Form.CMCid#" cfsqltype="cf_sql_numeric">
			</cfquery>

			<!--- Elimina Referencias de ASP --->
			<cfset sec.delUsuarioRol(form.Usucodigo,session.EcodigoSDC,'SIF','COMPRADOR')>
			<cfset sec.delUsuarioRef(form.Usucodigo,session.EcodigoSDC,'CMCompradores')>
			<cfset modo="ALTA">

		<cfelseif isdefined("Form.Cambio") and puedeSerJefe>
			<cfif form.Usucodigo neq form._Usucodigo>
				<cfquery name="rsValidaExiste" datasource="asp">
					select Usucodigo
					from UsuarioReferencia
					where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.EcodigoSDC#" >
					  and STabla='CMCompradores'
					  and Usucodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Usucodigo#" >
				</cfquery>

				<cfif rsValidaExiste.recordCount gt 0>
					<cf_errorCode	code = "50254" msg = "El registro que desea insertar o modificar, ya existe.">
				</cfif>

			</cfif>

			<!--- quita el bit de comprador default --->
			<cfif existeDefault and isdefined("Form.CMCdefault")>
				<cfquery name="updateCambioDefault" datasource="#Session.DSN#">
					update CMCompradores
					set CMCdefault = 0
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				</cfquery>

				<cfquery name="rs" datasource="minisif">
					select ts_rversion
					from CMCompradores
					where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				  	  and CMCid = <cfqueryparam value="#Form.CMCid#" cfsqltype="cf_sql_numeric">
				</cfquery>

				<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
					<cfinvokeargument name="arTimeStamp" value="#rs.ts_rversion#"/>
				</cfinvoke>

				<cfset form.ts_rversion = ts>

			</cfif>
			<cfif CMCcodigo_old NEQ form.CMCcodigo>
				<!--- Valida que el CMCcodigo no exista --->
				<cfquery name="valida" datasource="#session.DSN#">
					select 1 from CMCompradores
					where Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					  and CMCcodigo      = <cfqueryparam cfsqltype="cf_sql_char" value="#form.CMCcodigo#">
				</cfquery>
				<cfif valida.RecordCount gt 0>
					<cf_errorCode	code = "50255" msg = "El Código del Comprador ya existe, por favor intente de nuevo.">
				</cfif>
			</cfif>

			<cfquery name="update" datasource="#Session.DSN#">
				update CMCompradores
				set DEid = <cfif isdefined("form.DEid") and len(trim(form.DEid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#"><cfelse>null</cfif>,
					CMCnombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.Nombre)#">,
					CMCjefe = <cfif isdefined("Form.CMCjefe") and Len(Trim(Form.CMCjefe)) GT 0 and Form.CMCjefe NEQ "-1">
							  	<cfif Compare(Trim(Form.CMCjefe),Trim(Form.Usucodigo)) EQ 0>
									null
								<cfelse>
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMCjefe#">
								</cfif>
							  <cfelse>
								null
							  </cfif>,
					CMCdefault = <cfif isdefined("Form.CMCdefault")>1<cfelse>0</cfif>,
					CMCestado = <cfif isdefined("Form.CMCestado")>1<cfelse>0</cfif>,
					CMCfecha = 	<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
					CMTStarticulo = <cfif isdefined("Form.CMTSarticulo")>1<cfelse>0</cfif>,
					CMTSservicio = <cfif isdefined("Form.CMTSservicio")>1<cfelse>0</cfif>,
					CMTSactivofijo = <cfif isdefined("Form.CMTSactivofijo")>1<cfelse>0</cfif>,
					CMTSobra = <cfif isdefined("Form.CMTSobra")>1<cfelse>0</cfif>,
					CMCcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.CMCcodigo)#">,
					Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#">,
					CMCmontomax = <cfqueryparam cfsqltype="cf_sql_numeric" scale="2" value="#form.CMCmontomax#">,
					CMCautorizador = <cfif isdefined("Form.CMCautorizador")>1<cfelse>0</cfif>,
					CMCparticipa = <cfif isdefined("Form.CMCparticipa")>1<cfelse>0</cfif>
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				  	and CMCid = <cfqueryparam value="#Form.CMCid#" cfsqltype="cf_sql_numeric">
			</cfquery>

			<cfif isdefined("form.CMCestado")>
				<cfset sec.insUsuarioRol(form.Usucodigo,session.EcodigoSDC,'SIF','COMPRADOR')>
			<cfelse>
				<cfset sec.delUsuarioRol(form.Usucodigo,session.EcodigoSDC,'SIF','COMPRADOR')>
			</cfif>

			<cfif form.Usucodigo neq form._Usucodigo>
				<cfquery name="updateReferencia" datasource="asp">
					update UsuarioReferencia
					set Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
					  and llave = <cfqueryparam value="#Form.CMCid#" cfsqltype="cf_sql_varchar">
					  and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form._Usucodigo#">
					  and STabla = 'CMCompradores'
				</cfquery>
			</cfif>

			<cfset modo="ALTA">

		<cfelse>
			<cfif isdefined("form.especializacion") and form.especializacion NEQ ''>
				<cfquery name="checkExists" datasource="#Session.DSN#">
					select 1
					from CMEspecializacionComprador
					where CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMCid#">
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and CMTScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.CMTScodigo#">
				</cfquery>
				<cfif checkExists.recordCount EQ 0>
					<cftransaction>
						<cfquery name="insertd"  datasource="#session.DSN#">
							insert into CMEspecializacionComprador( CMCid, Ecodigo, CMTScodigo)
								values ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMCid#">,
										 <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
										 <cfqueryparam cfsqltype="cf_sql_char" value="#form.CMTScodigo#">
								)
							<cf_dbidentity1 datasource="#session.DSN#">
						</cfquery>
						<cf_dbidentity2 datasource="#session.DSN#" name="insertd">
					</cftransaction>
				</cfif>
				<cfset modo="CAMBIO">

			<cfelseif isdefined("form.accion") and form.accion eq 'delete'>
				<cfquery name="deleted" datasource="#session.DSN#">
					delete from CMEspecializacionComprador
					where CMElinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMElinea#">
						and CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMCid#">
						and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				</cfquery>
				<cfset modo="CAMBIO">
			</cfif>

		</cfif>

		<!----
		<!--- Inicia la Asignación del nivel de jerarquía según el jefe --->
		<cfset v_niv = 0>
		<cfset v_CMCid = 0>
		<cfset v_CMCnombre = "">
		<cfset v_CMCjefe = 0>
		<cfset v_Usucodigo = 0>
		<cfset v_CMCnivel = 0>

		<cfquery name="rsNivel" datasource="#Session.DSN#">
			update CMCompradores set CMCnivel = 0
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				and CMCjefe is null
		</cfquery>

		<cfquery name="rsCompradores" datasource="#Session.DSN#">
			select CMCid, CMCnombre, CMCjefe, Usucodigo, CMCnivel
			from CMCompradores
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			order by CMCnivel
		</cfquery>

		<cfset j = 1 >
		<cfset v_nivel = 0>
		<cfloop query="rsCompradores">
			<cfloop condition="1 EQ 1 and j lte 50">
				<cfset v_CMCid = rsCompradores.CMCid>
				<cfset v_CMCnombre = rsCompradores.CMCnombre>
				<cfset v_CMCjefe = rsCompradores.CMCjefe>
				<cfset v_Usucodigo = rsCompradores.Usucodigo>
				<cfset v_CMCnivel = rsCompradores.CMCnivel>

				<cfif len(trim(v_CMCid)) EQ 0 or  len(trim(v_CMCjefe)) EQ 0 >	<!---Si el CMCid esta vacio o el campo CMCjefe esta vacio es decir no tiene jefe---->
					<cfbreak>													<!---Salir--->
				</cfif>

				<cfquery name="rs1" datasource="#Session.DSN#">
					select coalesce(CMCnivel,0) as CMCnivel
					from CMCompradores
					where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
						and Usucodigo = #v_CMCjefe#
				</cfquery>
				<cfset v_nivel = rs1.CMCnivel>

				<cfquery name="rs2" datasource="#Session.DSN#">
					update CMCompradores set
					CMCnivel = #v_nivel# + 1
					where CMCjefe = #v_CMCjefe#
					and Usucodigo != #v_CMCjefe#
				</cfquery>
				<cfset j = j + 1 >
			</cfloop>
		</cfloop>

		<cfquery name="rs3" datasource="#Session.DSN#">
			update CMCompradores
			set CMCnivel = 0
			where CMCnivel is null
			and Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		</cfquery>

		<!--- Finaliza la Asignación del nivel de jerarquía según el jefe --->
		----->
		<!----/*-/-*/-*/-*/-*/-*/-*/*-/-*/-*/-*/-*/-*/-*/*-/-*/-*/-*/-*/-*/-*/*-/-*/-*/-*/-*/-*/-*---->
		<cfquery name="rsNivel" datasource="#Session.DSN#"><!---Actualizar los compradores que no tienen jefe, colocarlos en el primer nivel (0)----->
			update CMCompradores set CMCnivel = 0
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				and CMCjefe is null
		</cfquery>

		<cfquery name="rsCompradoresHijos" datasource="#session.DSN#"><!---Traer todos los compradores que TIENEN jefe---->
			select CMCnivel, CMCjefe, Usucodigo, CMCid,CMCnombre
			from CMCompradores
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				and CMCjefe is not null
				--and CMCnivel != 0
			order by CMCnivel
		</cfquery>

		<cfset vnNivel = ''><!---Inicialización de variable numérica(vn) que contendrá el nivel del padre--->

		<cfloop query="rsCompradoresHijos"><!---Para cada hijo---->
			<cfquery name="rsNivelPadre" datasource="#session.DSN#"><!---Obtener el nivel del padre---->
				select coalesce(CMCnivel,0) as CMCnivel
				from CMCompradores
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
					and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCompradoresHijos.CMCjefe#">
			</cfquery>

			<cfset vnNivel = rsNivelPadre.CMCnivel + 1><!---Sumarle al nivel del padre un nivel mas, que será el del hijo---->

			<cfquery datasource="#session.DSN#"><!---Actualiza el nivel del comprador----->
				update CMCompradores
					set CMCnivel = <cfqueryparam cfsqltype="cf_sql_integer" value="#vnNivel#">
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
					and CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCompradoresHijos.CMCid#">
			</cfquery>
		</cfloop>
		<!----/*-/-*/-*/-*/-*/-*/-*/*-/-*/-*/-*/-*/-*/-*/*-/-*/-*/-*/-*/-*/-*/*-/-*/-*/-*/-*/-*/-*---->
</cfif>

<form action="Compradores.cfm" method="post" name="sql">
	<cfif isDefined("Form.Nuevo")>
		<input name="Nuevo" type="hidden" value="<cfoutput>#Form.Nuevo#</cfoutput>">
	</cfif>
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<cfif not isdefined("form.Baja")><input name="CMCid" type="hidden" value="<cfif isdefined("Form.CMCid")><cfoutput>#Form.CMCid#</cfoutput></cfif>"></cfif>
    <input type="hidden" name="Pagina" value="<cfif isdefined("Pagenum_lista") and Pagenum_lista NEQ ""><cfoutput>#Pagenum_lista#</cfoutput><cfelseif isdefined("Form.PageNum")><cfoutput>#PageNum#</cfoutput></cfif>">
</form>

<html><head></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></html>

