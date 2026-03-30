<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="MSG_DebeDigitarUnPorcentajeEntre0Y100" Default="Debe digitar un porcentaje entre 0 y 100%" returnvariable="MSG_DebeDigitarUnPorcentajeEntre0Y100" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->
<cfif isdefined("Form.Cambio") or isdefined('form.DEid')>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif Form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>
<cfset Lvar_Modifica = 1>

<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#"
	ecodigo="#session.Ecodigo#" pvalor="2020" default="0" returnvariable="RentaPais"/>

<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#"
	ecodigo="#session.Ecodigo#" pvalor="250" default="1" returnvariable="AplicaRenta"/>

<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#"
	ecodigo="#session.Ecodigo#" pvalor="2045" default="0" returnvariable="idAuto"/>

<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#"
	ecodigo="#session.Ecodigo#" pvalor="2025" default="0" returnvariable="vUsaSBC"/>

<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#"
	ecodigo="#session.Ecodigo#" pvalor="2030" default="0" returnvariable="vActSDI"/>

<!---Empleado Salvador--->
<cfset esSalvador=false>
<cfif RentaPais eq 'RH_CalculoNominaRentaSLV.cfc'>
	<cfset esSalvador=true>
</cfif>
<!---Empleado Mexico--->
<cfquery name="rsEsMexico" datasource="#session.dsn#">
	select Pvalor from RHParametros where Ecodigo=#session.Ecodigo# and Pcodigo=2025
</cfquery>
<cfset esMexico = rsEsMexico.Pvalor>

<cfquery name="rsZE" datasource="#session.dsn#">
	select a.ZEid, a.ZEcodigo, a.ZEdescripcion
	from ZonasEconomicas a
	where a.CEcodigo = #session.CEcodigo#
</cfquery>

<cfif modo EQ "CAMBIO" and isdefined('form.DEid')>
	<cfquery name="rsform" datasource="#session.dsn#">
		select Ecodigo,Bid, NTIcodigo, DEidentificacion,
				DEnombre, DEapellido1, DEapellido2,
				CBTcodigo, DEcuenta, CBcc,
				Mcodigo, DEdireccion,
				DEcodPostal, DEtelefono1,
				DEtelefono2, DEemail, DEcivil,
				DEfechanac, DEsexo, DEcantdep,
				DEtarjeta,
				DEpassword, Ppais, DESeguroSocial,
				ZEid, DEsdi,
				DEobs1, DEobs2, DEobs3,
				DEobs4, DEobs5,DEdato1,
				DEdato2, DEdato3, DEdato4,
				DEdato5,DEdato6, DEdato7,
				DEinfo1, DEinfo2, DEinfo3,
				DEinfo4, DEinfo5, FEdatos1,
				FEdatos2,FEdatos3,FEinfo1,FEinfo2,FEobs1, FEobs2  ,
				BMUsucodigo, DEruta,
				BMfechaalta
		from DEModificables
		where Ecodigo=#session.Ecodigo#
	</cfquery>

	<cfquery datasource="#Session.DSN#" name="rsEmpleado">
		select 	distinct  a.DEid,			a.Ecodigo,			a.NTIcodigo, 		a.DEidentificacion,
				a.DEnombre, 	a.DEapellido1, 		a.DEapellido2,		a.DEsexo,
				a.CBcc, 		a.DEdireccion,
				a.DEcodPostal, 	a.DEcivil,			a.DEtelefono1,
				DEtelefono2,	DEemail,			a.DEfechanac,		a.DEobs1,
				a.DEobs2,		a.DEobs3,			a.DEobs4,			a.DEobs5,
				a.DEdato1,		a.DEdato2,			a.DEdato3,			a.DEdato4,
				a.DEdato5,		a.DEdato6,			a.DEdato7,			a.DEinfo1,
			   	a.DEinfo2, 		a.DEinfo3, 			a.DEinfo4,			a.DEinfo5,
			   	c.Mcodigo,		DEtarjeta, 			a.ts_rversion,		a.Bid,
			   	a.Ppais, 		a.CBTcodigo,		a.DEcuenta, 		b.VSdesc as NTIdescripcion,
				coalesce(a.DEporcAnticipo,0.00) as DEporcAnticipo,		a.IDInterfaz, RHRegimenid, <!---ERBG Se Agregó RHRegimenid--->
				a.DESeguroSocial, a.ZEid, a.DEsdi, RFC, CURP, a.NUP, a.NIT, a.DEtiposalario, a.DEtipocontratacion, <!---SML. Se agregaron campos a la base de datos para el tipo de salario y el tipo de contratacion--->
				a.DESindicalizado, a.DETipoPago,a.DErespetaSBC, a.Vigencia1, a.Vigencia2, a.Vigencia3,
				(select count(*) from LineaTiempo  where DEid =a.DEid) as regLTiempo
		from DatosEmpleado a

			left join VSidioma b
				on a.NTIcodigo = b.VSvalor
				and b.VSgrupo = 0

            inner join Monedas c
                on  a.Mcodigo = c.Mcodigo
                and a.Ecodigo = c.Ecodigo

		where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
		<cfif Session.cache_empresarial EQ 0>
			and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		</cfif>
	</cfquery>

	<!--- Buscar Usuario según Referencia --->
	<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">
	<cfset datos_usuario = sec.getUsuarioByRef(Form.DEid, Session.EcodigoSDC, 'DatosEmpleado')>
	<cfset tieneUsuarioTemporal = (datos_usuario.recordCount GT 0 and datos_usuario.Estado EQ 1)>
</cfif>

<!---
	ROL DEFINIDO PARA HENKEL PARA PERMITIR MODIFICAR ACCIONES REGISTRADAS DESDE INTERFAZ
	VERIFICA SI EL USUARIO TIENE EL ROL
--->
<cfquery name="rsRolDatosEmpInterfaz" datasource="asp">
	select 1
	from UsuarioRol
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.EcodigoSDC#">
	  and SScodigo = 'RH'
	  and SRcodigo = 'ADMAINT'
	  and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
</cfquery>
<!--- VERIFICA SI HAY UNA ACCION REGISTRADA --->
<cfif isdefined('rsEmpleado')>
	<!--- VERIFICA SI LOS DATOS VIENEN DE INTERFAZ Y ADEMÁS SI TIENE EL ROL PARA MODIFICAR
		SI CUMPLE AMBAS CONDICIONES ENTONCES LA VARIABLE SE ASIGNA UN 1 --->
	<cfif rsEmpleado.IDInterfaz GT 0 and rsRolDatosEmpInterfaz.RecordCount GT 0>
		<cfset Lvar_Modifica = 1>
	<cfelseif rsEmpleado.IDInterfaz GT 0 and rsRolDatosEmpInterfaz.RecordCount EQ 0>
		<cfset Lvar_Modifica = 0>
	</cfif>
</cfif>

<cfquery name="rsEtiquetasAll" datasource="#Session.DSN#">
	select RHEcol,
		   RHEtiqueta,
		   RHrequerido
	from RHEtiquetasEmpresa
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	and RHdisplay = 1
	and RHEcol like 'DE%'
</cfquery>

<cfquery name="rsEtiquetasDatos" dbtype="query">
	select RHEcol,
		   RHEtiqueta,
		   RHrequerido
	from rsEtiquetasAll
	where RHEcol like 'DEdato%'
</cfquery>

<cfquery name="rsEtiquetasObs" dbtype="query">
	select RHEcol,
		   RHEtiqueta,
		   RHrequerido
	from rsEtiquetasAll
	where RHEcol like 'DEobs%'
</cfquery>

<cfquery name="rsEtiquetasInfo" dbtype="query">
	select RHEcol,
		   RHEtiqueta,
		   RHrequerido
	from rsEtiquetasAll
	where RHEcol like 'DEinfo%'
</cfquery>

<!---<cfquery name="rsTipoIdent" datasource="#Session.DSN#">
	select NTIcodigo, NTIdescripcion, NTImascara
	from NTipoIdentificacion
	order by NTIcodigo
</cfquery>--->

<cfquery name="rsTipoIdent" datasource="#Session.DSN#">
 	select b.VSvalor as NTIcodigo, VSdesc as NTIdescripcion
	from Idiomas a
		inner join VSidioma b
		on b.Iid = a.Iid
		and b.VSgrupo = 0
	where Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#session.idioma#">
	<cfif #idAuto# EQ 1>
		and b.VSvalor = 'G'
	</cfif>
	order by b.VSvalor
</cfquery>

<!---<script language="javascript1.2" type="text/javascript">
	var validarIdentificacion = true;
	var id_mascaras = new Object();
	<cfoutput query="rsTipoIdent">
		id_mascaras['#trim(rsTipoIdent.NTIcodigo)#'] = '#trim(rsTipoIdent.NTImascara)#';
	</cfoutput>
</script>--->

<cfquery name="rsMoneda" datasource="#Session.DSN#">
	select Mcodigo, Mnombre
	from Monedas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>
<cfquery name="rsPais" datasource="asp">
select Ppais, Pnombre
from Pais
order by Pnombre
</cfquery>
<cfquery name="rsBancos" datasource="#Session.DSN#">
	select Bid, Bdescripcion
	from Bancos
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
</cfquery>
<cfparam name="LvarDGidDIR" default="-1">
<cfparam name="LvarDGidNAC" default="-1">
<cfif isdefined('form.DEid')>
    <cfquery name="rsDir" datasource="#Session.DSN#">
        select de.DGid, DIEMdestalles, dg.DGidPadre
        from DEmpleado de
            left outer join <cf_dbdatabase table="DistribucionGeografica" datasource="asp"> dg
                on dg.DGid = de.DGid
        where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
          and DIEMtipo = 0 <!---0-Direccion de Residencia 1-Direccion de Nacimiento--->
    </cfquery>
    <cfif rsDir.Recordcount GT 0 AND LEN(TRIM(rsDir.DGid))><cfset LvarDGidDIR = rsDir.DGid></cfif>
	<cfquery name="rsNac" datasource="#Session.DSN#">
        select de.DGid
        from DEmpleado de
            left outer join <cf_dbdatabase table="DistribucionGeografica" datasource="asp"> dg
                on dg.DGid = de.DGid
        where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
          and DIEMtipo = 1 <!---0-Direccion de Residencia 1-Direccion de Nacimiento--->
    </cfquery>
    <cfif rsNac.Recordcount GT 0 AND LEN(TRIM(rsNac.DGid))><cfset LvarDGidNAC = rsNac.DGid></cfif>
</cfif>

  <table width="95%" border="0" cellspacing="1" cellpadding="0" style="margin-left: 10px; margin-right: 10px;">
  	<tr><td colspan="2">&nbsp;</td></tr>
    <tr>
      <td width="10%" align="center" valign="top" style="padding-left: 10px; padding-right: 10px;">
	  	<cfif modo EQ 'CAMBIO' and isdefined('form.DEid')>
			<table width="100%" border="1" cellspacing="0" cellpadding="0">
			  <tr>
				<td align="center">
				  <cfinclude template="/rh/expediente/catalogos/frame-foto.cfm">
				</td>
			  </tr>
			</table>
		</cfif>
      </td>
      <td valign="top" nowrap>
			<form method="post" enctype="multipart/form-data" name="formDatosEmpleado" action="/cfmx/rh/expediente/catalogos/SQLdatosEmpleado.cfm" onsubmit="javascript: return validar( this.DEidentificacion.value, this.NTIcodigo.value );">
				<input type="hidden" name="DEid" id="DEid" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsEmpleado.DEid#</cfoutput></cfif>">
				<input type="hidden" name="modo" id="modo" value="<cfoutput>#modo#</cfoutput>">
                <input type="hidden" name="FechaSever" value="<cfoutput>#DateFormat(now(), "dd/mm/yyyy")#</cfoutput>">
                <input type="hidden" name="NivelCurp"  value="<cfoutput>#fnGetDirCUPR(LvarDGidNAC)#</cfoutput>">


				<cfset ts = "">
				<cfif modo NEQ "ALTA">
					<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" arTimeStamp="#rsEmpleado.ts_rversion#" returnvariable="ts"></cfinvoke>
					<input type="hidden" name="ts_rversion" value="<cfoutput>#ts#</cfoutput>">
				</cfif>
			  <table width="100%" border="0" cellspacing="0" cellpadding="2">
				<tr>
				  <td class="fileLabel"><cf_translate key="LB_Nombre" xmlfile="/rh/generales.xml">Nombre</cf_translate></td>
				  <td class="fileLabel"><cf_translate key="LB_Primer_Apellido" xmlfile="/rh/generales.xml">Primer Apellido</cf_translate></td>
				  <td class="fileLabel"><cf_translate key="LB_Segundo_Apellido" xmlfile="/rh/generales.xml">Segundo Apellido</cf_translate></td>
				</tr>
				<tr>
				  <td><input name="DEnombre"  <cfif isdefined ('rsform') and rsform.DEnombre eq 0 and isdefined('form.EstoyEnGestion')> disabled="disabled"</cfif> type="text" id="DEnombre2" size="40" maxlength="100" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsEmpleado.DEnombre#</cfoutput></cfif>"></td>
				  <td><input name="DEapellido1" <cfif isdefined ('rsform') and rsform.DEapellido1 eq 0 and isdefined('form.EstoyEnGestion')> disabled="disabled"</cfif>type="text" id="DEapellido12" size="40" maxlength="80" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsEmpleado.DEapellido1#</cfoutput></cfif>"></td>
				  <td><input name="DEapellido2" <cfif isdefined ('rsform') and rsform.DEapellido2 eq 0 and isdefined('form.EstoyEnGestion')> disabled="disabled"</cfif> type="text" id="DEapellido22" size="40" maxlength="80" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsEmpleado.DEapellido2#</cfoutput></cfif>"></td>
				</tr>
				<tr>
				  <td class="fileLabel"><cf_translate key="LB_Tipo_de_Identificacion" xmlfile="/rh/generales.xml">Tipo de Identificaci&oacute;n</cf_translate></td>
				  <td class="fileLabel"><cf_translate key="LB_Identificacion" xmlfile="/rh/generales.xml">Identificaci&oacute;n</cf_translate></td>
				  <td class="fileLabel">
                  <cf_translate key="LB_Num_Seguro_Social"  xmlfile="/rh/generales.xml">N&uacute;m. Seguro Social</cf_translate>

<!---					<cfif modo NEQ 'ALTA'>

					<cfelse>
					  &nbsp;
					</cfif>--->
				  </td>
				</tr>

				<tr>
					<td>
					  <cfoutput>
						<select name="NTIcodigo" onchange="javascript:cambiar_mascara(this, true);"
						<cfif (isdefined ('rsform') and rsform.NTIcodigo eq 0 and isdefined('form.EstoyEnGestion')) or (#idAuto# EQ 1) > disabled="disabled"</cfif>>
							<cfloop query="rsTipoIdent">
								<option value="#trim(rsTipoIdent.NTIcodigo)#" <cfif modo NEQ 'ALTA' and trim(rsEmpleado.NTIcodigo) EQ trim(rsTipoIdent.NTIcodigo)>selected</cfif>>
									#rsTipoIdent.NTIdescripcion#
								</option>
							</cfloop>
						</select>
						</cfoutput>
					</td>

					<cfif #modo# EQ 'ALTA' and #idAuto# EQ 1>
						<cfquery name="rsIDAuto" datasource="#session.dsn#">
							select coalesce(max(<cf_dbfunction name="to_number" args="DEidentificacion">),0)+1 as nexID
							from DatosEmpleado
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
								and NTIcodigo = 'G'
						</cfquery>
						<input type="hidden" name="DEidentificacion" value="<cfif modo EQ 'ALTA' and #idAuto# EQ 1 ><cfoutput>#rsIDAuto.nexID#</cfoutput></cfif>">
					</cfif>
				  <td>
				    <input size="40" maxlength="60"  <cfif (isdefined ('rsform') and rsform.DEidentificacion eq 0 and isdefined('form.EstoyEnGestion')) or (#idAuto# EQ 1)> disabled="disabled"</cfif> name="DEidentificacion" type="text" id="DEidentificacion"
						value="<cfif modo NEQ 'ALTA'><cfoutput>#rsEmpleado.DEidentificacion#</cfoutput>
								<cfelseif modo EQ 'ALTA' and #idAuto# EQ 1 ><cfoutput>#LSnumberformat(rsIDAuto.nexID,9)#</cfoutput></cfif>">
				  </td>

				  <td nowrap="nowrap">
					<cfif modo NEQ 'ALTA'>
					<cfoutput>
						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="LB_Modificar_Num_Seguro_Social "
						Default="Modificar N&uacute;m. Seguro Social"
						returnvariable="LB_Modificar_Num_Seguro_Social"/>
						<input
							name="DESeguroSocial"
							readonly="tru"
							type="text"
							id="DESeguroSocial"
							size="40"
							maxlength="60"
							 <cfif (isdefined ('rsform') and rsform.DESeguroSocial eq 0 and isdefined('form.EstoyEnGestion'))> disabled="disabled"</cfif>
							value="<cfif isdefined("rsEmpleado.DESeguroSocial") and len(trim(rsEmpleado.DESeguroSocial))>#rsEmpleado.DESeguroSocial#<!---<cfelse><cf_translate  key="LB_Sin Definir">*** Sin Definir ***</cf_translate>---></cfif>">
						&nbsp;&nbsp;
						<cfif not (isdefined ('rsform') and rsform.DESeguroSocial eq 0 and isdefined('form.EstoyEnGestion'))>
						<a href="javascript: ModificarSeguroSoc(#rsEmpleado.DEid#);" tabindex="-1">
							<img src="/cfmx/rh/imagenes/iindex.gif"
								alt="#LB_Modificar_Num_Seguro_Social#"
								name="Img_Cambio"
								border="0"
								>
						</a>
						</cfif>
					</cfoutput>
                    <cfelse>
                    	<input
							name="DESeguroSocial"
							type="text"
							id="DESeguroSocial"
							size="40"
							maxlength="60"
							value="">
					</cfif>
				  </td>
				</tr>
				<tr>
				  <td class="fileLabel"><cf_translate key="LB_Estado_Civil" xmlfile="/rh/generales.xml">Estado Civil</cf_translate></td>
				  <td class="fileLabel"><cf_translate key="LB_Fecha_de_Nacimiento" >Fecha de Nacimiento</cf_translate></td>
				  <td class="fileLabel"><cf_translate key="LB_Sexo" xmlfile="/rh/generales.xml">Sexo</cf_translate></td>
				</tr>
				<tr>
				  <td><select name="DEcivil" id="DEcivil" <cfif isdefined ('rsform') and rsform.DEcivil eq 0 and isdefined('form.EstoyEnGestion')> disabled="disabled"</cfif>>
					  <option value="0" <cfif modo NEQ 'ALTA' and rsEmpleado.DEcivil EQ 0> selected</cfif>><cf_translate key="LB_Soltero">Soltero(a)</cf_translate></option>
					  <option value="1" <cfif modo NEQ 'ALTA' and rsEmpleado.DEcivil EQ 1> selected</cfif>><cf_translate key="LB_Casado">Casado(a)</cf_translate></option>
					  <option value="2" <cfif modo NEQ 'ALTA' and rsEmpleado.DEcivil EQ 2> selected</cfif>><cf_translate key="LB_Divorciado">Divorciado(a)</cf_translate></option>
					  <option value="3" <cfif modo NEQ 'ALTA' and rsEmpleado.DEcivil EQ 3> selected</cfif>><cf_translate key="LB_Viudo">Viudo(a)</cf_translate></option>
					  <option value="4" <cfif modo NEQ 'ALTA' and rsEmpleado.DEcivil EQ 4> selected</cfif>><cf_translate key="LB_UnionLibre">Union Libre</cf_translate></option>
					  <option value="5" <cfif modo NEQ 'ALTA' and rsEmpleado.DEcivil EQ 5> selected</cfif>><cf_translate key="LB_Separado">Separado(a)</cf_translate></option>
					</select></td>
				  <td>
				  <cfset LvarRO=''>
					<cfif modo NEQ 'ALTA'>
						<cfset fecha = LSDateFormat(rsEmpleado.DEfechanac, "DD/MM/YYYY")>
					<cfelse>
						<cfset fecha = LSDateFormat(Now(), "DD/MM/YYYY")>
					</cfif>
					<cfif isdefined ('rsform') and rsform.DEfechanac eq 0>
						<cfset LvarRO='true'>
					<cfelse>
						<cfset LvarRO='false'>
					</cfif>
               		<table>
                    	<tr>
                        	<td><cf_sifcalendario form="formDatosEmpleado" value="#fecha#" name="DEfechanac" readonly="#LvarRO#" onChange="calcularEdad()"></td>
                        	<td>&nbsp;<label id="anos" style="font-weight:normal; font-style:normal"></label></td>
                        </tr>
                    </table>
				  </td>
				  <td><select name="DEsexo" id="select2" <cfif isdefined ('rsform') and rsform.DEsexo eq 0 and isdefined('form.EstoyEnGestion')> disabled="disabled"</cfif>>
                    <option value="M" <cfif modo NEQ 'ALTA' and rsEmpleado.DEsexo EQ 'M'> selected</cfif>><cf_translate key="LB_Masculino">Masculino</cf_translate></option>
                    <option value="F" <cfif modo NEQ 'ALTA' and rsEmpleado.DEsexo EQ 'F'> selected</cfif>><cf_translate key="LB_Femenino">Femenino</cf_translate></option>
                  </select></td>
				</tr>

				<cfif esSalvador>
					<tr>
						<td>Identificador Tributario (NIT)</td>
						<td>Identificador Pensiones (NUP)</td>
					</tr>
					<tr>
						<td><input name="NIT" 		 type="text"   value="<cfif modo NEQ 'ALTA'><cfoutput>#rsEmpleado.NIT#</cfoutput></cfif>"  id="NIT"  maxlength="13" size="20" <cfif isdefined('form.EstoyEnGestion')> disabled="disabled"</cfif>/>
						<!---<cfdiv id="ValidaNIT" bindOnLoad="false" bind="url:ValidaDatosEmpleado.cfm?NIT={NIT@none}&Alta={Alta@click}">--->
						<cfif isdefined("form.DEid") and len(trim(form.DEid))>
							<cfdiv id="ValidaNIT" bindOnLoad="false" bind="url:ValidaDatosEmpleado.cfm?NIT={NIT}&modo={modo}&DEid={DEid}">
						<cfelse>
							<cfdiv id="ValidaNIT" bindOnLoad="false" bind="url:ValidaDatosEmpleado.cfm?NIT={NIT}&modo={modo}">
						</cfif>

						</td>
						<td><input name="NUP" type="text"   value="<cfif modo NEQ 'ALTA'><cfoutput>#rsEmpleado.NUP#</cfoutput></cfif>" id="NUP" maxlength="18" size="25" <cfif isdefined('form.EstoyEnGestion')> disabled="disabled"</cfif>/>
							<cfif isdefined("form.DEid") and len(trim(form.DEid))>
								<cfdiv id="ValidaNUP" bindOnLoad="false" bind="url:ValidaDatosEmpleado.cfm?NUP={NUP}&modo={modo}&DEid={DEid}">
							<cfelse>
								<cfdiv id="ValidaNUP" bindOnLoad="false" bind="url:ValidaDatosEmpleado.cfm?NUP={NUP}&modo={modo}">
							</cfif>

						</td>
				   </tr>
				</cfif>


				<!---RFC y CURP--->
				<cfif vUsaSBC EQ 1>
					<tr>
						<td>RFC</td>
						<td>CURP</td>
					</tr>
					<tr>
						<td><input name="RFC" 		 type="text"   value="<cfif modo NEQ 'ALTA'><cfoutput>#rsEmpleado.RFC#</cfoutput></cfif>"  id="RFC"  maxlength="13" size="20" <cfif isdefined('form.EstoyEnGestion')> disabled="disabled"</cfif>/></td>
						<td><input name="CURP" 		 type="text"   value="<cfif modo NEQ 'ALTA'><cfoutput>#rsEmpleado.CURP#</cfoutput></cfif>" id="CURP" maxlength="18" size="25" <cfif isdefined('form.EstoyEnGestion')> disabled="disabled"</cfif>/></td>
					   <!--- <cfif NOT isdefined('form.EstoyEnGestion')>
						<td>
							<input name="btnCalculo" type="button" value="Calcular RFC/CURP"  class="btnNormal" onclick="CalularRFCCURP()" /> 
						</td>						
					   </cfif> --->						   
				   </tr>
				</cfif>

				


				<tr>
				  <td class="fileLabel"><cf_translate key="LB_Direccion" xmlfile="/rh/generales.xml">Direcci&oacute;n</cf_translate> de Residencia</td>

				  <td class="fileLabel"><cf_translate key="LB_CP" xmlfile="/rh/generales.xml"> C&oacute;digo Postal</cf_translate></td>
			      <td class="fileLabel">
					<cfif Session.Params.ModoDespliegue EQ 1>
					  <cf_translate key="LB_Ruta_De_La_Foto"  xmlfile="/rh/generales.xml">Ruta de la foto</cf_translate>
					<cfelse>
					  &nbsp;
					</cfif>
				  </td>
				</tr>
				<tr>
				  <td colspan="0" class="fileLabel">
				  <cfif modo NEQ 'ALTA'>
				  	<cfset lvarDireccion = rsEmpleado.DEdireccion>
				  </cfif>
				  <cfif isdefined('form.DEid')>
					<cfif len(trim(rsDir.DGid)) neq 0>
						<cfset dir = fnGetDireccion("asp",rsDir.DGid,rsDir.DIEMdestalles)>
						<cfif len(trim(lvarDireccion)) eq 0>
							<cfset lvarDireccion = dir>
						<cfelseif len(trim(dir)) neq len(trim(lvarDireccion))>
							<input id="Ndireccion" name="Ndireccion" type="hidden" value="<cfoutput>#dir#</cfoutput>"/>
						</cfif>
					</cfif>
				  </cfif>
				  	<textarea name="DEdireccion" <cfif isdefined ('rsform') and rsform.DEdireccion eq 0 and isdefined('form.EstoyEnGestion')> disabled="disabled"</cfif> id="DEdireccion" rows="2" style="width: 99%;"><cfif modo NEQ 'ALTA'><cfoutput>#trim(lvarDireccion)#</cfoutput></cfif></textarea>
				  </td>

				  <td valign="top"><input name="DEcodPostal" <cfif isdefined ('rsform') and rsform.DEcodPostal eq 0 and isdefined('form.EstoyEnGestion')> disabled="disabled"</cfif> type="text" id="DEcodPostal" size="25" maxlength="25" value="<cfif modo NEQ 'ALTA'><cfoutput>#Trim(rsEmpleado.DEcodPostal)#</cfoutput></cfif>"></td>

				  <td valign="top">
					<cfif Session.Params.ModoDespliegue EQ 1>
				  	<input name="rutaFoto" type="file" id="rutaFoto2" <cfif isdefined ('rsform') and rsform.DEruta eq 0 and isdefined('form.EstoyEnGestion')> disabled="disabled"</cfif>>
					<cfelse>
					&nbsp;
					</cfif>
				  </td>
		        </tr>

				<tr>
					<cfset CURP = "">
					<cfif isdefined('rsNac') and len(trim(rsNac.DGid)) neq 0>
						<cfset CURP = fnGetCURP(rsNac.DGid)>
					<cfelse>
						<cfset CURP = "***No Definido***">
					</cfif>
					<td colspan="2">Lugar de Nacimiento <label><strong><cfoutput>#CURP#</cfoutput></strong></label></td>
				</tr>


				<tr>
					<td colspan="3">&nbsp;</td>
				</tr>
				<!----=============================================================---->
				<tr>
					<td class="fileLabel"><cf_translate key="LB_Banco" xmlfile="/rh/generales.xml">Banco</cf_translate></td>
					<td class="fileLabel"><cf_translate key="LB_Tipo_Cuenta">Tipo cuenta</cf_translate></td>
					<td class="fileLabel"><cf_translate key="LB_Cuenta" xmlfile="/rh/generales.xml">Cuenta</cf_translate></td>
				</tr>
				<tr>
					<td>
						<select name="Bid" <cfif isdefined ('rsform') and rsform.Bid eq 0 and isdefined('form.EstoyEnGestion')> disabled="disabled"</cfif>>
							<option value=""<cfif modo NEQ 'ALTA' and Len(Trim(rsEmpleado.Bid)) EQ 0> selected</cfif>>(<cf_translate key="CMB_Ninguno">Ninguno</cf_translate>)</option>
						  <cfoutput query="rsBancos">
							<option value="#rsBancos.Bid#"<cfif modo NEQ 'ALTA' and rsEmpleado.Bid EQ rsBancos.Bid> selected</cfif>>#rsBancos.Bdescripcion#</option>
						  </cfoutput>
						</select>
					</td>
					<td>
					  <select name="CBTcodigo" <cfif isdefined ('rsform') and rsform.CBTcodigo eq 0 and isdefined('form.EstoyEnGestion')> disabled="disabled"</cfif>>
					    <option value="0" <cfif modo NEQ 'ALTA' and rsEmpleado.CBTcodigo EQ 0>selected</cfif>>
					      <cf_translate key="CMB_Corriente">Corriente</cf_translate>
				        </option>
					    <option value="1" <cfif modo NEQ 'ALTA' and rsEmpleado.CBTcodigo EQ 1>selected</cfif>>
					      <cf_translate key="CMB_Ahorro">Ahorro</cf_translate>
				        </option>
				      </select>
					</td>
					<td>
						<input type="text" name="DEcuenta" <cfif isdefined ('rsform') and rsform.DEcuenta eq 0 and isdefined('form.EstoyEnGestion')> disabled="disabled"</cfif> value="<cfif modo NEQ 'ALTA'><cfoutput>#Trim(HTMLEditFormat(rsEmpleado.DEcuenta))#</cfoutput></cfif>"  maxlength="50"  size="25">
					</td>
				</tr>
				<!----=============================================================---->
				<tr>
				  <td class="fileLabel"><cf_translate key="LB_Cuenta_Cliente">Cuenta Cliente</cf_translate></td>
				  <td class="fileLabel"><cf_translate key="LB_Moneda" xmlfile="/rh/generales.xml">Moneda</cf_translate></td>
					<td class="fileLabel"><cf_translate key="LB_Direccion_Electronica">Direcci&oacute;n electr&oacute;nica</cf_translate></td>
				</tr>
				<tr>
				  <td><input name="CBcc" <cfif isdefined ('rsform') and rsform.CBcc eq 0 and isdefined('form.EstoyEnGestion')> disabled="disabled"</cfif> type="text" id="CBcc" size="25" maxlength="25" value="<cfif modo NEQ 'ALTA'><cfoutput>#Trim(rsEmpleado.CBcc)#</cfoutput></cfif>"></td>
				  <td><select name="Mcodigo" id="Mcodigo" <cfif isdefined ('rsform') and rsform.Mcodigo eq 0 and isdefined('form.EstoyEnGestion')> disabled="disabled"</cfif>>
					  <cfoutput query="rsMoneda">
						<option value="#rsMoneda.Mcodigo#"<cfif modo NEQ 'ALTA' and rsEmpleado.Mcodigo EQ rsMoneda.Mcodigo> selected</cfif>>#rsMoneda.Mnombre#</option>
					  </cfoutput>
					  </select>
				  </td>
					<td>
					  <input type="text" name="DEemail" <cfif isdefined ('rsform') and rsform.DEemail eq 0 and isdefined('form.EstoyEnGestion')> disabled="disabled"</cfif> value="<cfif modo NEQ 'ALTA'><cfoutput>#trim(HTMLEditFormat(rsEmpleado.DEemail))#</cfoutput></cfif>"  maxlength="60"  size="40" />
                    </td>
				</tr>
				<tr>
				  <td class="fileLabel"><cf_translate key="LB_Telefono_de_Residencia">Tel&eacute;fono de Residencia</cf_translate></td>
				  <td class="fileLabel"><cf_translate key="LB_Telefono_Celular">Tel&eacute;fono Celular</cf_translate></td>
				  <td class="fileLabel"><cf_translate key="LB_Tipo_Pago">Tipo Pago</cf_translate></td>
				</tr>
				<tr>
				  <td><input name="DEtelefono1" <cfif isdefined ('rsform') and rsform.DEtelefono1 eq 0 and isdefined('form.EstoyEnGestion')> disabled="disabled"</cfif> type="text" id="DEtelefono13"  value="<cfif modo NEQ 'ALTA'><cfoutput>#rsEmpleado.DEtelefono1#</cfoutput></cfif>" size="30" maxlength="30"></td>
				  <td><input name="DEtelefono2" <cfif isdefined ('rsform') and rsform.DEtelefono2 eq 0 and isdefined('form.EstoyEnGestion')> disabled="disabled"</cfif>type="text" id="DEtelefono2"  value="<cfif modo NEQ 'ALTA'><cfoutput>#rsEmpleado.DEtelefono2#</cfoutput></cfif>" size="30" maxlength="30"></td>
					<td>
						<select id="cmbTipoPago" name="cmbTipoPago">
							<option value="0" <cfif IsDefined('rsEmpleado') and rsEmpleado.DETipoPago eq 0 and modo NEQ 'ALTA'>selected</cfif>><cf_translate key="LB_Tipo_Transf">Transferencia</cf_translate></option>
							<option value="1" <cfif IsDefined('rsEmpleado') and rsEmpleado.DETipoPago eq 1 and modo NEQ 'ALTA'>selected</cfif>><cf_translate key="LB_Tipo_Cheque">Cheque</cf_translate></option>
						</select>
					</td>
				</tr>
				<cfif AplicaRenta EQ 1>
					<tr>
						<td class="fileLabel"><cf_translate key="LB_Tipo_de_Empleado">Tipo de Empleado</cf_translate></td>
						<!---<td class="fileLabel"><cf_translate key="LB_Numero_de_Concesiones">N&uacute;mero de Concesiones</cf_translate></td>
						<td>
							<cfif modo EQ "ALTA" OR (modo EQ "CAMBIO" AND tieneUsuarioTemporal)>
								<input type="checkbox" name="chkEnviarTemporal" value="1"><cf_translate key="CHK_EnviarUsuarioTemporal">Enviar Usuario Temporal</cf_translate>
							<cfelse>
								&nbsp;
							</cfif>
						</td>--->
					</tr>
				<cfelse>
					<tr>
						<td class="fileLabel"><cf_translate key="LB_Id_de_Tarjeta">Id de Tarjeta</cf_translate></td>
						<td class="fileLabel"><cf_translate key="LB_Contrasena_para_marcas">Contrase&ntilde;a para marcas</cf_translate></td>
						<td>
							<cfif modo EQ "ALTA" or (modo EQ "CAMBIO" AND tieneUsuarioTemporal)>
								<input type="checkbox" name="chkEnviarTemporal" value="1"><cf_translate key="CHK_EnviarUsuarioTemporal">Enviar Usuario Temporal</cf_translate>
							</cfif>
						</td>
					</tr>
				</cfif>

				<cfif AplicaRenta EQ 1>
					<cfquery name="rsTiposEmpleado" datasource="#Session.DSN#">
						select TEid, TEdescripcion as Descripcion
						from TiposEmpleado
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						order by TEdescripcion
					</cfquery>
					<cfif modo NEQ 'ALTA'>
						<cfquery name="rsEmpleadosTipo" datasource="#Session.DSN#">
							select TEid, ETNumConces
							from EmpleadosTipo
							where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpleado.DEid#">
						</cfquery>
					</cfif>
					<tr>
				  		<td>
							<select name="TEid">
								<option value="">(<cf_translate key="CMB_Seleccionar_Tipo_De_Empleado">Seleccionar Tipo de Empleado</cf_translate>)</option>
									<cfoutput query="rsTiposEmpleado">
										<option value="#TEid#"<cfif modo NEQ 'ALTA' and rsTiposEmpleado.TEid EQ rsEmpleadosTipo.TEid> selected</cfif>>#Descripcion#</option>
									</cfoutput>
							</select>
				  		</td>
				  		<td colspan="1">
							<input type="checkbox" name="DESindicalizado" id="DESindicalizado"  <cfif modo NEQ 'ALTA' and trim(rsEmpleado.DESindicalizado) neq '' and rsEmpleado.DESindicalizado eq 1>checked</cfif>>
							Sindicalizado
						</td>
						<td colspan="2">
							<input type="checkbox" name="DErespetaSBC" id="DErespetaSBC"  <cfif modo NEQ 'ALTA' and trim(rsEmpleado.DErespetaSBC) neq '' and rsEmpleado.DErespetaSBC eq 1>checked</cfif>>
							Empleado con incapacidad se le respeta el SBC
						</td>
				  		<!---<td><input name="ETNumConces" type="text" size="18" maxlength="15"  onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,0);"  onKeyUp="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsEmpleadosTipo.ETNumConces#</cfoutput><cfelse>0</cfif>"></td>
				  		<td>&nbsp;</td>--->
					</tr>

					<tr>
						<td class="fileLabel"><cf_translate key="LB_Id_de_Tarjeta">Id de Tarjeta</cf_translate></td>
						<td class="fileLabel"  nowrap><cf_translate key="LB_Contrasena_para_marcas">Contrase&ntilde;a para marcas</cf_translate></td>
					</tr>

				</cfif>
				<tr>
					<td>
						<input name="DEtarjeta" <cfif isdefined ('rsform') and rsform.DEtarjeta eq 0 and isdefined('form.EstoyEnGestion')> disabled="disabled"</cfif> type="text" id="DEtarjeta"  value="<cfif modo NEQ 'ALTA'><cfoutput>#trim(rsEmpleado.DEtarjeta)#</cfoutput></cfif>" size="10" maxlength="10">
						<cfif isdefined("form.DEid") and len(trim(form.DEid))>
							<cfdiv id="ValidaTarjeta" bindOnLoad="false" bind="url:ValidaDatosEmpleado.cfm?DEtarjeta={DEtarjeta}&modo={modo}&DEid={DEid}">
						<cfelse>
							<cfdiv id="ValidaTarjeta" bindOnLoad="false" bind="url:ValidaDatosEmpleado.cfm?DEtarjeta={DEtarjeta}&modo={modo}">
						</cfif>
					</td>
					<td colspan="2"><input name="DEpassword" <cfif isdefined ('rsform') and rsform.DEpassword eq 0 and isdefined('form.EstoyEnGestion')> disabled="disabled"</cfif> type="password" size="18" maxlength="20" value="<cfif modo NEQ 'ALTA'>**********</cfif>"></td>
				</tr>
                <!---SML.Inicio Agregar Tipo de Salario del Trabajador--->
                <tr>
					<td class="fileLabel">Tipo de Salario</td>
					<td class="fileLabel">Tipo de Contrataci&oacute;n</td>
                    <td class="fileLabel">R&eacute;gimen de Contrataci&oacute;n</td>
				</tr>
                <tr>
					<td class="fileLabel"><select name="DEtiposalario" id="DEtiposalario">
					  <option value="-1" <cfif modo NEQ 'ALTA' and rsEmpleado.DEtiposalario EQ -1> selected</cfif>> -- Seleccione Tipo de Salario -- </option>
					  <option value="0" <cfif modo NEQ 'ALTA' and rsEmpleado.DEtiposalario EQ 0> selected</cfif>>Fijo</option>
					  <option value="1" <cfif modo NEQ 'ALTA' and rsEmpleado.DEtiposalario EQ 1> selected</cfif>>Mixto</option>
					  <option value="2" <cfif modo NEQ 'ALTA' and rsEmpleado.DEtiposalario EQ 2> selected</cfif>>Variable</option>
					  </select></td>
					<td class="fileLabel">
						<cfquery datasource="#session.dsn#" name="rsTC">
							Select * from CSATTiposContrato
						</cfquery>


						<select name="DEtipocontratacion" id="DEtipocontratacion">
						<cfloop query="rsTC">
							<cfoutput>
						  		<option value="#rsTC.TCid#" <cfif modo NEQ 'ALTA' and rsEmpleado.DEtipocontratacion EQ rsTC.TCid> selected</cfif>> #rsTC.CSATDescripcion# </option>
							</cfoutput>
						  <!--- <option value="0" <cfif modo NEQ 'ALTA' and rsEmpleado.DEtipocontratacion EQ 0> selected</cfif>> -- Seleccione Tipo de Contrataci&oacute;n -- </option>
						  <option value="1" <cfif modo NEQ 'ALTA' and rsEmpleado.DEtipocontratacion EQ 1> selected</cfif>>Fijo</option>
						  <option value="2" <cfif modo NEQ 'ALTA' and rsEmpleado.DEtipocontratacion EQ 2> selected</cfif>>Eventual</option>
						  <option value="3" <cfif modo NEQ 'ALTA' and rsEmpleado.DEtipocontratacion EQ 3> selected</cfif>>Construcci&oacute;n</option> --->
						</cfloop>
						</select>
					</td>
                    <!---Régimen de Contratación ERBG Inicio--->
                    <td>
                        <cfquery name="rsRegimen" datasource="#Session.DSN#">
                            select RHRegimenid,RHRegimencodigo, RHRegimendescripcion
                            from RHCFDI_Regimen
                            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                            order by RHRegimencodigo
                        </cfquery>
							<cfoutput>
                                <select name="RegimenContra" tabindex="1">
                                    <option value=0>- <cf_translate key="CMB_Ninguno">Ninguno</cf_translate> -</option>
                                    <cfloop query="rsRegimen">
                                        <option value="#rsRegimen.RHRegimenid#"
                                            <cfif modo NEQ 'ALTA' and rsEmpleado.RHRegimenid eq rsRegimen.RHRegimenid >
                                                selected
                                            </cfif> >
                                            #rsRegimen.RHRegimencodigo# - #rsRegimen.RHRegimendescripcion#
                                        </option>
                                    </cfloop>
                                </select>
                            </cfoutput>
                    </td>
                    <!---Régimen de Contratación ERBG Fin--->
				</tr>
				<!---SML.Inicio Agregar Tipo de Salario del Trabajador--->
				<tr>
					<td class="fileLabel"><cf_translate key="LB_Pais_de_Nacimiento">Nacionalidad</cf_translate></td>
					<!---ljimenez se incluye la zona economica para uso en mexico--->
					<td class="fileLabel"><cf_translate key="LB_ZonaEconomica">Zona Econ&oacute;mica</cf_translate></td>

					<cfif vUsaSBC EQ 1>
						<td class="fileLabel"><cf_translate key="LB_SalarioDiarioIntegrado">Salario Diario Integrado (SDI)</cf_translate></td>
					</cfif>
					<td>
				</tr>
				<tr>
					<td class="fileLabel">
						<select name="Ppais" <cfif isdefined ('rsform') and rsform.Ppais eq 0 and isdefined('form.EstoyEnGestion')> disabled="disabled"</cfif>>
							<option value="">(<cf_translate key="CMB_Seleccione_un_Pais">Seleccione un Pa&iacute;s</cf_translate>)</option>
							<cfoutput query="rsPais">
								<option value="#Ppais#"<cfif modo NEQ 'ALTA' and rsPais.Ppais EQ rsEmpleado.Ppais> selected</cfif>>#Pnombre#</option>
							</cfoutput>
						</select>
					</td>
					<td>

					<cfoutput>
					<select name="ZEid"  <cfif isdefined ('rsform') and rsform.ZEid eq 0 and isdefined('form.EstoyEnGestion')> disabled="disabled"</cfif>>
						<option value="">-- <cf_translate key="CMB_NoAsignada">No Asignada</cf_translate> --</option>
						<cfloop query="rsZE">
							<option value="#rsZE.ZEid#" <cfif modo NEQ "ALTA" and rsZE.ZEid eq rsEmpleado.ZEid>selected</cfif>>
								#rsZE.ZEcodigo# - #rsZE.ZEdescripcion#
							</option>
						</cfloop>
					</select>
					</cfoutput>
					</td>

					<cfif vUsaSBC EQ 1 >
						<cfif vActSDI EQ 1>

							<td>
							  <input  name="DEsdi" type="text" style="text-align: right;"
							   onfocus="javascript:this.value=qf(this); this.select();"
							   onblur="javascript:fm(this,2); asignar(this, 'M');"
							   onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
							   value="<cfif isdefined("rsEmpleado") and rsEmpleado.RecordCount GT 0 ><cfoutput>#LSCurrencyFormat(rsEmpleado.DEsdi,'none')#</cfoutput><cfelse>0.000</cfif>"
								size="16" maxlength="16" />
							</td>
						<cfelse>
							<td>
							  <input  readonly="true" name="DEsdi" type="text" style="text-align: right;"
							   onfocus="javascript:this.value=qf(this); this.select();"
							   onblur="javascript:fm(this,2); asignar(this, 'M');"
							   onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
							   value="<cfif isdefined("rsEmpleado") and rsEmpleado.RecordCount GT 0 ><cfoutput>#LSCurrencyFormat(rsEmpleado.DEsdi,'none')#</cfoutput><cfelse>0.000</cfif>"
								size="16" maxlength="16" />
							</td>
						</cfif>
					</cfif>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
				</tr>
				<tr><td colspan="3">&nbsp;</td></tr>
				<tr>
				  <td colspan="3" class="<cfoutput>#Session.preferences.Skin#_thcenter</cfoutput>" style="padding-left: 5px;"><cf_translate key="LB_AnticipoDeSalario">Anticipo de Salario</cf_translate></td>
				</tr>
				<tr>
					<td>
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td width="21%" nowrap class="fileLabel">
									<cf_translate key="LB_PorcentajeDeAnticipo">Porcentaje de anticipo</cf_translate>:&nbsp;
								</td>
								<td width="79%">
									<input name="DEporcAnticipo" style="text-align:right"
										onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
										onFocus="javascript:this.select();"
										onchange="javascript: fm(this,2); return validaMontos(); "
										type="text" id="DEporcAnticipo"
										value="<cfif modo NEQ 'ALTA'><cfoutput>#LSCurrencyFormat(rsEmpleado.DEporcAnticipo,'none')#</cfoutput><cfelse>0.00</cfif>"
										size="15" maxlength="6"
										<cfif isdefined('form.EstoyEnGestion')>readOnly</cfif>>
								</td>
							</tr>
						</table>
					</td>
				</tr>

				<tr><td colspan="3">&nbsp;</td></tr>
				<tr>
				  <td colspan="3" class="<cfoutput>#Session.preferences.Skin#_thcenter</cfoutput>" style="padding-left: 5px;"><cf_translate key="DatosVariables">Datos Variables</cf_translate></td>
				</tr>
				<tr><td colspan="3" align="center">&nbsp;</td></tr>
				<tr>
				  <td colspan="3" align="center"> <table width="100%" border="0" cellspacing="0" cellpadding="0">

					<cfif isdefined('rsEtiquetasAll') and rsEtiquetasAll.recordCount GT 0>
						<cfif  isdefined('rsEtiquetasDatos')>
							<cfloop query="rsEtiquetasDatos">
							  <!--- Campos Variables de Datos del empleado --->
							  <tr>
								<td width="21%" nowrap class="fileLabel"><cfoutput>#rsEtiquetasDatos.RHEtiqueta#</cfoutput>:</td>
								<td width="79%">
								  <cfoutput>
									<input name="#rsEtiquetasDatos.RHEcol#" <cfif isdefined('rsform') and #Evaluate("rsform.#rsEtiquetasDatos.RHEcol#")# eq 0 and isdefined('form.EstoyEnGestion')>disabled="disabled"</cfif> onFocus="this.select()" type="text" id="#rsEtiquetasDatos.RHEcol#" value="<cfif modo NEQ 'ALTA'><cfoutput>#Evaluate("rsEmpleado.#rsEtiquetasDatos.RHEcol#")#</cfoutput></cfif>" size="30" maxlength="30">
								  </cfoutput> </td>
							  </tr>
							</cfloop>
						</cfif>
						<cfif  isdefined('rsEtiquetasInfo')>
							<cfloop query="rsEtiquetasInfo">
							  <!--- Campos variables de informacion del empleado --->
							  <tr>
								<td width="21%" nowrap class="fileLabel"><cfoutput>#rsEtiquetasInfo.RHEtiqueta#</cfoutput>:</td>
								<td width="79%">
								  <cfoutput>
									<cfswitch expression="#rsEtiquetasInfo.RHEcol#">
									<cfcase value="DEinfo5">
										<select name="#rsEtiquetasInfo.RHEcol#">
											<option value="" <cfif modo NEQ 'ALTA' and #Evaluate("rsEmpleado.#rsEtiquetasInfo.RHEcol#")# EQ ''> selected</cfif>></option>
											<option value="Se envío evaluacion" <cfif modo NEQ 'ALTA' and #Evaluate("rsEmpleado.#rsEtiquetasInfo.RHEcol#")# EQ 'Se envío evaluacion'> selected</cfif>>Se envío evaluacion</option>
											<option value="Recibió evaluacion" <cfif modo NEQ 'ALTA' and #Evaluate("rsEmpleado.#rsEtiquetasInfo.RHEcol#")# EQ 'Recibió evaluacion'> selected</cfif>>Recibió evaluacion</option>
											<option value="Firmó evaluacion" <cfif modo NEQ 'ALTA' and #Evaluate("rsEmpleado.#rsEtiquetasInfo.RHEcol#")# EQ 'Firmó evaluacion'> selected</cfif>>Firmó evaluacion</option>
										</select>
									</cfcase>
									<cfdefaultcase>
										<input name="#rsEtiquetasInfo.RHEcol#"  <cfif isdefined('rsform') and #Evaluate("rsform.#rsEtiquetasInfo.RHEcol#")# eq 0 and isdefined('form.EstoyEnGestion')>disabled="disabled"</cfif>onFocus="this.select()" type="text" id="#rsEtiquetasInfo.RHEcol#" value="<cfif modo NEQ 'ALTA'><cfoutput>#Evaluate("rsEmpleado.#rsEtiquetasInfo.RHEcol#")#</cfoutput></cfif>" size="100" maxlength="100">
									</cfdefaultcase>
									</cfswitch>
								  </cfoutput> </td>
							  </tr>
							</cfloop>
						</cfif>

						<cfif  isdefined('rsEtiquetasObs')>
							<cfloop query="rsEtiquetasObs">
							  <!--- Campos variables de observaciones --->
							  <tr>
								<td width="21%" nowrap class="fileLabel"><cfoutput>#rsEtiquetasObs.RHEtiqueta#</cfoutput>:</td>
								<td width="79%">
								  <cfoutput>
									<input name="#rsEtiquetasObs.RHEcol#" <cfif isdefined('rsform') and #Evaluate("rsform.#rsEtiquetasObs.RHEcol#")# eq 0 and isdefined('form.EstoyEnGestion')>disabled="disabled"</cfif> onFocus="this.select()" type="text" id="#rsEtiquetasObs.RHEcol#" value="<cfif modo NEQ 'ALTA'><cfoutput>#Evaluate("rsEmpleado.#rsEtiquetasObs.RHEcol#")#</cfoutput></cfif>" size="100" maxlength="255">
								  </cfoutput> </td>
							  </tr>
							</cfloop>
						</cfif>
					</cfif>
					</table></td>
				</tr>
				<tr>
					<td colspan="3" align="center">&nbsp;</td>
				</tr>
				<cfif modo NEQ 'ALTA'>
					<tr>
						<td colspan="3" class="<cfoutput>#Session.preferences.Skin#_thcenter</cfoutput>" style="padding-left: 5px;"><cf_translate key="VigenciasContratos">Vigencias Contratos</cf_translate></td>
					</tr>
					<tr>
					<td colspan="3" align="center">&nbsp;</td>
					</tr>
					<tr>
						<td class="fileLabel"><cf_translate key="Vigencia Contrato1" >Vigencia Contrato 1</cf_translate></td>
						<td class="fileLabel"><cf_translate key="Vigencia Contrato2" >Vigencia Contrato 2</cf_translate></td>
						<td class="fileLabel"><cf_translate key="Vigencia Contrato3" >Vigencia Contrato 3</cf_translate></td>
					</tr>
					<tr>
						<cfset _vigencia1 = LSDateFormat(rsEmpleado.Vigencia1, "DD/MM/YYYY")>
						<cfset _vigencia2 = LSDateFormat(rsEmpleado.Vigencia2, "DD/MM/YYYY")>
						<cfset _vigencia3 = LSDateFormat(rsEmpleado.Vigencia3, "DD/MM/YYYY")>
						
						<td><cf_sifcalendario form="formDatosEmpleado" value="#_vigencia1#" name="vigencia1"></td>
						<td><cf_sifcalendario form="formDatosEmpleado" value="#_vigencia2#" name="vigencia2"></td>
						<td><cf_sifcalendario form="formDatosEmpleado" value="#_vigencia3#" name="vigencia3"></td>
									
					</tr>
				</cfif>
				<tr>
				  <td colspan="3" align="center">&nbsp;</td>
				</tr>
				<tr>
				  <td colspan="3" align="center">
				  	<cfif Session.Params.ModoDespliegue EQ 1>
				  		<cfset exclude = "">
				  		<cfif modo neq  "ALTA" and Lvar_Modifica EQ 0>
							<cfif isdefined("rsEmpleado") and rsEmpleado.regLTiempo eq 0>
								<cfset exclude = "CAMBIO">
							<cfelse>
								<cfset exclude = "CAMBIO,BAJA">
							</cfif>
						<cfelseif modo neq  "ALTA" and Lvar_Modifica EQ 1>
							<cfif isdefined("rsEmpleado") and rsEmpleado.regLTiempo eq 0>
							<cfelse>
								<cfset exclude = "BAJA">
							</cfif>
						</cfif>
						<cf_botones modo="#modo#" exclude="#exclude#">
					<cfelseif Session.Params.ModoDespliegue EQ 0
							and not(modo neq  "ALTA" and Lvar_Modifica EQ 0)>
						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Guardar"
						Default="Guardar"
						xmlfile="/rh/generales.xml"
						returnvariable="BTN_Guardar"/>
						<cfif isdefined('form.EstoyEnGestion') and form.EstoyEnGestion EQ 'S'>
							<cfif isdefined('rsModificaDE') and rsModificaDE.RecordCount GT 0 and rsModificaDE.Pvalor EQ 1>
								<input type="submit" name="Cambio" id="Cambio" value="<cfoutput>#BTN_Guardar#</cfoutput>">
							</cfif>
							
						<cfelse>
							<input type="submit" name="Cambio" id="Cambio" value="<cfoutput>#BTN_Guardar#</cfoutput>">

						</cfif>

					</cfif>
				  </td>
				</tr>
				<cfif modo neq  "ALTA" and Lvar_Modifica EQ 0>
					<tr><td colspan="3" align="center">*
						<cf_translate key="MSG_RegistroNoSePuedeModificar">
						Este registro no se puede modificar debido a <br>
						que se gener&oacute; en otra aplicaci&oacute;n y el usuario no est&aacute; autorizado
						</cf_translate>.
					</td></tr>
				</cfif>
			  </table>
			</form>
      </td>
    </tr>
  </table>
<script language="JavaScript" type="text/javascript" src="/cfmx/rh/js/calendar.js">//</script>
<script language="JavaScript" type="text/javascript" src="/cfmx/rh/js/utilesMonto.js">//</script>
<script language="JavaScript" src="/cfmx/sif/js/qForms/qforms.js">//</script>
<iframe id="frdDaEm" name="frdDaEm" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src=""></iframe>

<!--- mascara para la identificacion del empleado --->
<!--- <script language="JavaScript1.2">
	oIdentificacionMask = new Mask("", "");
	oIdentificacionMask.attach(document.formDatosEmpleado.DEidentificacion,"", "", "", "", "", "");
</script>	  --->

<script language="JavaScript" type="text/javascript">
//------------------------------------------------------------------------------------------
	arrNombreObjs = new Array();
	arrNombreEtiquetas = new Array();

	//Objetos de los datos variables del empleado
	<cfloop query="rsEtiquetasDatos">
		<cfif rsEtiquetasDatos.RHrequerido EQ 1>
			arrNombreObjs[arrNombreObjs.length] = '<cfoutput>#rsEtiquetasDatos.RHEcol#</cfoutput>';
			arrNombreEtiquetas[arrNombreEtiquetas.length] = '<cfoutput>#rsEtiquetasDatos.RHEtiqueta#</cfoutput>';
		</cfif>
	</cfloop>
	<cfloop query="rsEtiquetasObs">
		<cfif rsEtiquetasObs.RHrequerido EQ 1>
			arrNombreObjs[arrNombreObjs.length] = '<cfoutput>#rsEtiquetasObs.RHEcol#</cfoutput>';
			arrNombreEtiquetas[arrNombreEtiquetas.length] = '<cfoutput>#rsEtiquetasObs.RHEtiqueta#</cfoutput>';
		</cfif>
	</cfloop>
	<cfloop query="rsEtiquetasInfo">
		<cfif rsEtiquetasInfo.RHrequerido EQ 1>
			arrNombreObjs[arrNombreObjs.length] = '<cfoutput>#rsEtiquetasInfo.RHEcol#</cfoutput>';
			arrNombreEtiquetas[arrNombreEtiquetas.length] = '<cfoutput>#rsEtiquetasInfo.RHEtiqueta#</cfoutput>';
		</cfif>
	</cfloop>
//------------------------------------------------------------------------------------------
function calcularEdad()
{
	var fr = document.getElementById("frdDaEm");
	fr.src = 'iframe-datosEmpleado.cfm?fechaNac='+document.formDatosEmpleado.DEfechanac.value+'&fechaHoy='+document.formDatosEmpleado.FechaSever.value;
}
function funcFecha() {calcularEdad();} //esta funcion se llama al seleccionar una fecha con el calendarpopup
//------------------------------------------------------------------------------------------
function CalularRFCCURP()
{
	if (confirm('¿Esta seguro que desea calcular el RFC y el CURP?'))
	{
		var fr  	= document.getElementById("frdDaEm");
		fecha   	= document.formDatosEmpleado.DEfechanac.value;
		sexo    	= document.formDatosEmpleado.DEsexo.value;
		nombre  	= document.formDatosEmpleado.DEnombre.value;
		paterno 	= document.formDatosEmpleado.DEapellido1.value;
		materno 	= document.formDatosEmpleado.DEapellido2.value;
		NivelCurp	= document.formDatosEmpleado.NivelCurp.value;
		fr.src = 'iframe-datosEmpleado.cfm?RFCCURP=true&fecha='+fecha+'&sexo='+sexo+'&nombre='+nombre+'&paterno='+paterno+'&materno='+materno+'&NivelCurp='+NivelCurp;
	}
}
//------------------------------------------------------------------------------------------
	function deshabilitarValidacion(){
		validarIdentificacion = false;

		objForm.NTIcodigo.required = false;
		objForm.DEidentificacion.required = false;
		objForm.DEnombre.required = false;
		objForm.CBcc.required = false;
		objForm.DEcivil.required = false;
		objForm.DEfechanac.required = false;
		objForm.Mcodigo.required = false;
		objForm.DEsexo.required = false;
		<cfif AplicaRenta EQ 1>
		objForm.TEid.required = false;
		objForm.ETNumConces.required = false;
		</cfif>
		//Validacion de los datos variables por empresa
		for(var i=0;i<arrNombreObjs.length;i++)
			eval("objForm." + arrNombreObjs[i] + ".required = false;");
	}
//------------------------------------------------------------------------------------------
	function habilitarValidacion(){
		validarIdentificacion = true;

		objForm.NTIcodigo.required = true;
		<cfif idAuto EQ 0>
		objForm.DEidentificacion.required = true;
		</cfif>
		objForm.DEnombre.required = true;
		objForm.CBcc.required = true;
		objForm.DEcivil.required = true;
		objForm.DEfechanac.required = true;
		objForm.Mcodigo.required = true;
		objForm.DEsexo.required = true;
		<cfif AplicaRenta EQ 1>
		objForm.TEid.required = true;
		objForm.ETNumConces.required = false;
		</cfif>
		//Validacion de los datos variables por empresa
		for(var i=0;i<arrNombreObjs.length;i++)
			eval("objForm." + arrNombreObjs[i] + ".required = true;");
	}


	function validacionAjax(){
		var err = '';
		var div = 'targetDiv';
		//validad que no exista un emppleado con el mismo NIT
		err = ValidaNIT(div);
		<!---alert(err)--->
		return (err);
	}

	function validar( _v, _m ){

		var err = '';

		<!---En el caso de que la emrpesa sea de Mexico, valida que el numero seguro social sea igual a 11 caracteres--->
		<cfif esMexico EQ 1>
			var dato = document.formDatosEmpleado.DESeguroSocial.value.replace(' ','')
			<!---dato = dato.replace('*** Sin Definir ***','')
			alert('.'+dato + '.'+'*** Sin Definir ***' + '.')
			alert(dato == '*** Sin Definir ***')--->
			if ( dato.length > 0  && dato.length != 11){
				err= err + 'El Seguro social debe estar compuesto de 11 caracteres. \n'
			}

		</cfif>

		if( err == '' ){
			validar_mascara( _v, _m );
		}
		else{
			alert(err);
			return false;
		}
	}


	function validar_mascara( _v, _m ){
		document.formDatosEmpleado.NTIcodigo.disabled = false;
		document.formDatosEmpleado.DEidentificacion.disabled = false;
		document.formDatosEmpleado.DEnombre.disabled = false;
		document.formDatosEmpleado.CBcc.disabled = false;
		document.formDatosEmpleado.DEcivil.disabled = false;
		document.formDatosEmpleado.DEfechanac.disabled = false;
		document.formDatosEmpleado.Mcodigo.disabled = false;
		document.formDatosEmpleado.DEsexo.disabled = false;
		document.formDatosEmpleado.NTIcodigo.disabled = false;
		document.formDatosEmpleado.DEapellido1.disabled = false;
		document.formDatosEmpleado.DEapellido2.disabled = false;
		document.formDatosEmpleado.DEdireccion.disabled = false;
		document.formDatosEmpleado.DEtelefono1.disabled = false;
		document.formDatosEmpleado.DEtelefono2.disabled = false;
		document.formDatosEmpleado.DEemail.disabled = false;
		document.formDatosEmpleado.Ppais.disabled = false;
		//Validacion de los datos variables por empresa
		for(var i=0;i<arrNombreObjs.length;i++)
		eval("document.formDatosEmpleado." + arrNombreObjs[i] + ".disabled = false;");


		if ( !validarIdentificacion ) return true;

		var LvarValor = _v;

		var LvarMascara = '';
		if (id_mascaras[_m]){
			LvarMascara = id_mascaras[_m];
		}

		var r = "x#*", rx = {"x": new RegExp("[A-Za-z]"), "#": new RegExp("[0-9]"), "*": new RegExp("[A-Za-z0-9]") };

		if (LvarMascara.length == 0)
			return true;

		var v = 0, u = -1, pf=true, m = 0, nv = "", sv = "";
		if (LvarValor.length > 0)
		{
			while (m <= LvarMascara.length)
			{
				c = LvarValor.charAt(v);
				p = LvarMascara.charAt(m);
				if ( (p!="") && (r.indexOf(p) > -1) )
				{
					if (v >= LvarValor.length)
					{
						pf = false;
						break;
					}

					if (rx[p].test(c))
					{
						nv = nv + c;
						sv = sv + c;
						m++;
						u = nv.length;
					}
					v++;
				}
				else
				{
					if (p == "!")
						p = LvarMascara.charAt(m++);
					nv = nv + p;
					m++;
					if (p == c) v++;
				}
			}

		}
		//this.strippedValue = sv;
		nv = nv.substring(0, u);

		/*if ( (LvarValor != nv) || (LvarValor.length != LvarMascara.length) ){
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_SePresentaronLosSiguientesErrores"
			Default="Se presentaron los siguientes errores"
			returnvariable="MSG_SePresentaronLosSiguientesErrores"/>

			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_ElCampoIdentificacionDebeTenerElFormato"
			Default="El campo Identificación debe tener el formato"
			returnvariable="MSG_ElCampoIdentificacionDebeTenerElFormato"/>

			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Alfanumericos_Letras"
			Default="*: alfanuméricos, x: letras"
			returnvariable="MSG_AlfanumericosLetras"/>

			alert('<cfoutput>#MSG_SePresentaronLosSiguientesErrores#</cfoutput>:\n - <cfoutput>#MSG_ElCampoIdentificacionDebeTenerElFormato#</cfoutput>: ' + LvarMascara + '\n    [<cfoutput>#MSG_AlfanumericosLetras#</cfoutput>]' )
			return false
		}*/

		return true
	}

	function cambiar_mascara(obj, borrar){
		<cfif modo eq 'ALTA'>
			if ( borrar ) document.formDatosEmpleado.DEidentificacion.value = '';
		</cfif>
		<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#"
			ecodigo="#session.Ecodigo#" pvalor="16000003" default="N" returnvariable="consecutivoEmpleado"/>
		<cfif consecutivoEmpleado eq 'S'>
			if (obj.value == 'G') {
				<cfif modo eq 'ALTA'>
					document.getElementById('DEidentificacion').value = 'Consecutivo';
				</cfif>				
				document.getElementById('DEidentificacion').readOnly = true;
			} else {
				document.getElementById('DEidentificacion').readOnly = false;
			}
		</cfif>
		//if (id_mascaras[obj.value])	oIdentificacionMask.mask = id_mascaras[obj.value];
	}
	cambiar_mascara(document.formDatosEmpleado.NTIcodigo, <cfif modo neq 'ALTA'>false<cfelse>true</cfif>  );

//------------------------------------------------------------------------------------------
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
//------------------------------------------------------------------------------------------
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("formDatosEmpleado");

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Tipo_de_Identificacion"
	Default="Tipo de Identificación"
	xmlfile="/rh/generales.xml"
	returnvariable="MSG_TipoDeIdentificacion"/>

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Identificacion"
	Default="Identificación"
	xmlfile="/rh/generales.xml"
	returnvariable="MSG_Identificacion"/>

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Nombre"
	Default="Nombre"
	xmlfile="/rh/generales.xml"
	returnvariable="MSG_Nombre"/>

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Cuenta_Cliente"
	Default="Cuenta Cliente"
	returnvariable="MSG_CuentaCliente"/>

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Estado_Civil"
	Default="Estado Civil"
	xmlfile="/rh/generales.xml"
	returnvariable="MSG_EstadoCivil"/>

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Fecha_de_Nacimiento"
	Default="Fecha de Nacimiento"
	returnvariable="MSG_FechaDeNacimieto"/>

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Moneda"
	xmlfile="/rh/generales.xml"
	Default="Moneda"
	returnvariable="MSG_Moneda"/>

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Sexo"
	Default="Sexo"
	xmlfile="/rh/generales.xml"
	returnvariable="MSG_Sexo"/>

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Tipo_de_Empleado"
	Default="Tipo de Empleado"
	returnvariable="MSG_TipoDeEmpleado"/>

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Numero_de_Concesiones"
	Default="Número de Concesiones"
	returnvariable="MSG_NUmeroDeConcesiones"/>
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_PorcentajeDeAnticipoDeSalario"
	Default="Porcentaje de Anticipo de Salario"
	returnvariable="MSG_PorcentajeDeAnticipoDeSalario"/>
	objForm.NTIcodigo.required = true;
	objForm.NTIcodigo.description = "<cfoutput>#MSG_TipoDeIdentificacion#</cfoutput>";



	<cfif idAuto EQ 0>
		objForm.DEidentificacion.required = true;
		objForm.DEidentificacion.description = "<cfoutput>#MSG_Identificacion#</cfoutput>";
	</cfif>

	objForm.DEnombre.required = true;
	objForm.DEnombre.description = "<cfoutput>#MSG_Nombre#</cfoutput>";
	objForm.CBcc.required = true;
	objForm.CBcc.description = "<cfoutput>#MSG_CuentaCliente#</cfoutput>";
	objForm.DEcivil.required = true;
	objForm.DEcivil.description = "<cfoutput>#MSG_EstadoCivil#</cfoutput>";
	objForm.DEfechanac.required = true;
	objForm.DEfechanac.description = "<cfoutput>#MSG_FechaDeNacimieto#</cfoutput>";
	objForm.Mcodigo.required = true;
	objForm.Mcodigo.description = "<cfoutput>#MSG_Moneda#</cfoutput>";
	objForm.DEsexo.required = true;
	objForm.DEsexo.description = "<cfoutput>#MSG_Sexo#</cfoutput>";
	<cfif AplicaRenta EQ 1>
	objForm.TEid.required = true;
	objForm.TEid.description = "<cfoutput>#MSG_TipoDeEmpleado#</cfoutput>";
	objForm.ETNumConces.required = false;
	objForm.ETNumConces.description = "<cfoutput>#MSG_NUmeroDeConcesiones#</cfoutput>";
	</cfif>
	objForm.DEporcAnticipo.required = true;
	objForm.DEporcAnticipo.description = "<cfoutput>#MSG_PorcentajeDeAnticipoDeSalario#</cfoutput>";

	//Validacion de los datos variables por empresa
	for(var i=0;i<arrNombreObjs.length;i++){
		eval("objForm." + arrNombreObjs[i] + ".required = true;");
		eval("objForm." + arrNombreObjs[i] + ".description = '" + arrNombreEtiquetas[i] + "';");
	}


	// Valida el campo ya sea si es monto o porcentaje

	function validaMontos() {
		var f = document.formDatosEmpleado;
		var PorCAnticipo = new Number(qf(f.DEporcAnticipo.value));

		// Por Porcentaje
		if (PorCAnticipo > 100) {
			alert('<cfoutput>#MSG_DebeDigitarUnPorcentajeEntre0Y100#</cfoutput>');
			f.DEporcAnticipo.select();
			return false;
		}
		return true;
	}
	function ModificarSeguroSoc(llave){
		var PARAM  = "/cfmx/rh/expediente/catalogos/ModSeguroSocial.cfm?DEid="+ llave
		var x = open(PARAM,'ModSeguroSocial','left=400,top=250,scrollbars=yes,resizable=yes,width=500,height=300');
		x.focus();
	}
calcularEdad();
</script>
<cffunction name="CalculaFecha" access="public">
<script language="javascript" type="text/javascript">
	alert('JEJE ESTOY EN UNA FUNCION COLDFUSION');
</script>
</cffunction>

<cffunction name="fnGetDireccion"  access="private" returntype="string">
	<cfargument name="Conexion"  	 type="string"   required="no">
	<cfargument name="DGid"  	 	 type="numeric"  required="yes">
	<cfargument name="Direccion"  	 type="string"   required="yes">

	<cfif not isdefined('Arguments.Conexion')>
		<cfset Arguments.Conexion = "asp">
	</cfif>

   <cfquery datasource="#Arguments.Conexion#" name="rFnDist">
		select DGid, DGidPadre, DGDescripcion
			from DistribucionGeografica
		  where DGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DGid#">
	</cfquery>
	<cfif len(trim(rFnDist.DGidPadre)) neq 0>
		<cfreturn fnGetDireccion(Arguments.Conexion, rFnDist.DGidPadre, Arguments.Direccion & ", " & rFnDist.DGDescripcion)>
	</cfif>
	 <cfreturn Arguments.Direccion & ", " & rFnDist.DGDescripcion>
</cffunction>

<cffunction name="fnGetDirCUPR"  access="private" returntype="string">
	<cfargument name="DGid"  	 	 type="numeric"  required="yes">
    <cfargument name="Conexion"  	 type="string"   required="no" default="ASP">

   <cfquery datasource="#Arguments.Conexion#" name="rFnCurp">
		select CURP, DGcodigo, DGidPadre
            from DistribucionGeografica a
                inner join NivelGeografico b
                 	on b.NGid = a.NGid
		  where DGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DGid#">
	</cfquery>

	<cfif rFnCurp.RecordCount GT 0 and rFnCurp.CURP EQ 1>
    	<cfreturn rFnCurp.DGcodigo>
    </cfif>
    <cfif rFnCurp.RecordCount GT 0 and rFnCurp.CURP EQ 0 and LEN(TRIM(rFnCurp.DGidPadre))>
    	<cfreturn fnGetDirCUPR(rFnCurp.DGidPadre, Arguments.Conexion)>
    <cfelse>
    	<cfreturn "N/A">
    </cfif>
</cffunction>


<cffunction name="fnGetCURP" access="private" output="true" returntype="string">
	<cfargument name='DGid'		type='numeric' 	required='true'>
	<cfinvoke component="asp.Geografica.componentes.DistribucionGeografica" method="fnGetListadoDist" returnvariable="rsPadreDist">
		<cfinvokeargument name="DGid"   	value="#Arguments.DGid#">
	</cfinvoke>
	<cfif rsPadreDist.RecordCount gt 0>
		<cfloop query="rsPadreDist">
			<cfif rsPadreDist.CURP eq '1'>
				<cfreturn rsPadreDist.DGDescripcion>
			<cfelseif  len(trim(rsPadreDist.DGidPadre)) gt 0>
				<cfreturn fnGetCURP(rsPadreDist.DGidPadre)>
			<cfelse>
				<cfreturn "***No Definido***">
			</cfif>
		</cfloop>
	<cfelse>
		<cfreturn "***No Definido***">
	</cfif>
</cffunction>