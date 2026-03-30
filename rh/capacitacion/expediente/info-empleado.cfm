<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MG_El_empleado_seleccionado_no_tiene_un_usuario_correspondiente"
	Default="El empleado seleccionado no tiene un usuario correspondiente."
	returnvariable="MG_El_empleado_seleccionado_no_tiene_un_usuario_correspondiente"/> 


<cfif isdefined("Url.DEid") and not isdefined("Form.DEid")>
	<cfparam name="Form.DEid" default="#Url.DEid#">
</cfif>

<!--- Se utiliza cuando el que consulta es el empleado --->
	<cfif isdefined("Form.DEid")>
		<cfquery name="rsReferencia" datasource="asp">
			select Usucodigo
			from UsuarioReferencia
			where llave = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEid#">
<!---			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.EcodigoSDC#">--->
<!--- 20140502 LZ. Se comenta, porque el Usucodigo es Corporativo --->
			and STabla = 'DatosEmpleado'
		</cfquery>
		
		<cfif rsReferencia.RecordCount GT 0>
			<cfquery datasource="#Session.DSN#" name="rsEmpleado">
				select a.DEid,
					   a.Ecodigo,
					   a.Bid,
					   a.NTIcodigo, 
					   a.DEidentificacion, 
					   a.DEnombre, 
					   a.DEapellido1, 
					   a.DEapellido2, 
					   case a.DEsexo when 'M' then '<cf_translate key="LB_Masculino" xmlFile="/rh/generales.xml">Masculino</cf_translate>' when 'F' then '<cf_translate key="LB_Femenino" xmlFile="/rh/generales.xml">Femenino</cf_translate>' else 'N/D' end as Sexo,
					   a.CBTcodigo, 
					   a.DEcuenta, 
					   a.CBcc, 
					   a.DEdireccion, 
					   case a.DEcivil 
							when 0 then '<cf_translate key="LB_Soltero" xmlFile="/rh/generales.xml">Soltero(a)</cf_translate>' 
							when 1 then '<cf_translate key="LB_Casado" xmlFile="/rh/generales.xml">Casado(a)</cf_translate>' 
							when 2 then '<cf_translate key="LB_Divorciado" xmlFile="/rh/generales.xml">Divorciado(a)</cf_translate>' 
							when 3 then '<cf_translate key="LB_Viudo" xmlFile="/rh/generales.xml">Viudo(a)</cf_translate>' 
							when 4 then '<cf_translate key="LB_UnionLibre" xmlFile="/rh/generales.xml">Unión Libre</cf_translate>' 
							when 5 then '<cf_translate key="LB_Separado" xmlFile="/rh/generales.xml">Separado(a)</cf_translate>' 
							else '' 
					   end as EstadoCivil, 
					   a.DEfechanac as FechaNacimiento, 
					   a.DEcantdep, 
					   a.DEobs1, 
					   a.DEobs2, 
					   a.DEobs3, 
					   a.DEdato1, 
					   a.DEdato2, 
					   a.DEdato3, 
					   a.DEdato4, 
					   a.DEdato5, 
					   a.DEinfo1, 
					   a.DEinfo2, 
					   a.DEinfo3, 
                       a.DEtext1,
                       a.DEtext2,
                       a.DEtext3,
					   #rsReferencia.Usucodigo# as Usucodigo, 
					   a.Ulocalizacion, 
					   a.DEsistema, 
					   a.ts_rversion,
					   b.NTIdescripcion,
					   c.Mnombre,
					   coalesce(d.Bdescripcion, '<cf_translate key="LB_Ninguno" xmlFile="/rh/generales.xml">Ninguno</cf_translate>') as Bdescripcion
				from DatosEmpleado a
				
				inner join NTipoIdentificacion b
				on a.NTIcodigo = b.NTIcodigo
				and b.Ecodigo = #Session.Ecodigo#				

				inner join Monedas c
				on a.Mcodigo = c.Mcodigo
				
				left outer join Bancos d
				on a.Ecodigo = d.Ecodigo
				  and a.Bid = d.Bid

				where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
			</cfquery>
		<cfelse>
			<cf_throw message="#MG_El_empleado_seleccionado_no_tiene_un_usuario_correspondiente#" errorcode="10040">
		</cfif>
	</cfif>
	
	<cf_translatedata name="get" tabla="RHPuestos" col="p.RHPdescpuesto" returnvariable="LvarRHPdescpuesto">
		<cf_translatedata name="get" tabla="CFuncional" col="cf.CFdescripcion" returnvariable="LvarCFdescripcion">
	<cfquery datasource="#Session.DSN#" name="otrosdatos">
		select coalesce(p.RHPcodigoext,p.RHPcodigo) as RHPcodigo, #LvarRHPdescpuesto# as RHPdescpuesto, pl.CFid, cf.CFcodigo, #LvarCFdescripcion# as CFdescripcion
		from LineaTiempo lt
		
		inner join RHPuestos p
		on lt.Ecodigo=p.Ecodigo
		and coalesce(lt.RHPcodigoAlt,lt.RHPcodigo)=p.RHPcodigo
	
		inner join RHPlazas pl
		on lt.Ecodigo=pl.Ecodigo
		and lt.RHPid=pl.RHPid	
	
		inner join CFuncional cf
		on pl.Ecodigo=cf.Ecodigo
		and pl.CFid=cf.CFid
		
		where lt.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
		and lt.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between lt.LTdesde and lt.LThasta
	</cfquery>	
<cfoutput>
<table width="100%" border="0" cellpadding="3" cellspacing="0">
  <tr>
    <td width="10%" rowspan="9" align="center" valign="top" style="padding-left: 10px; padding-right: 10px; padding-top: 10px;" nowrap><cfinclude template="/rh/expediente/consultas/frame-foto.cfm"></td> 
	<td class="fileLabel" width="15%" nowrap><cf_translate key="NombreCompleto" xmlFile="/rh/autogestion/autogestion.xml">Nombre Completo</cf_translate>: </td>
	<td colspan="3"><b><font size="3">#rsEmpleado.DEnombre# #rsEmpleado.DEapellido1# #rsEmpleado.DEapellido2#</font></b></td>
    <td width="18%" align="right">
		<cfif not (isdefined("consulta") or isdefined("LvarAuto"))>
			<a href="listaEmpleados.cfm"><cf_translate key="SeleccionarEmpleado" xmlFile="/rh/autogestion/autogestion.xml">Seleccionar Empleado</cf_translate>: <img src="/cfmx/rh/imagenes/find.small.png" name="imageBusca" id="imageBusca" border="0"></a>
		</cfif>
	</td>
  </tr>
  <tr>
    <td class="fileLabel" nowrap><cf_translate key="CedulaExp" xmlFile="/rh/autogestion/autogestion.xml">#HTMLEditformat(rsEmpleado.NTIdescripcion)#</cf_translate>:</td>
	<td width="30%">#rsEmpleado.DEidentificacion#</td>

    <td class="fileLabel" nowrap width="11%"><cf_translate key="Puesto" xmlFile="/rh/autogestion/autogestion.xml">Puesto</cf_translate>:</td>
	<td colspan="2">#trim(otrosdatos.RHPcodigo)# - #otrosdatos.RHPdescpuesto#</td>
  </tr>
  <tr>
    <td class="fileLabel" nowrap><cf_translate key="Sexo" xmlFile="/rh/autogestion/autogestion.xml">Sexo</cf_translate>:</td>
	<td>#rsEmpleado.Sexo#</td>
    <td class="fileLabel" nowrap width="11%"><cf_translate key="CentroFuncional" xmlFile="/rh/autogestion/autogestion.xml">Centro Funcional</cf_translate>:</td>
	<td colspan="2">#trim(otrosdatos.CFcodigo)# - #otrosdatos.CFdescripcion#</td>
  </tr>
  <tr>
    <td class="fileLabel" nowrap><cf_translate key="EstadoCivil" xmlFile="/rh/autogestion/autogestion.xml">Estado Civil</cf_translate>:</td>
	<td>#rsEmpleado.EstadoCivil#</td>
	<td class="fileLabel" nowrap width="11%"><cfif not (isdefined("consulta2") or  isdefined("LvarAuto"))><cf_translate key="LB_Ver_Expediente" xmlFile="/rh/autogestion/autogestion.xml">Ver Expediente</cf_translate>&nbsp;<a  href="javascript: Expediente('<cfoutput>#trim(form.DEID)#</cfoutput>');" ><img border="0" src="/cfmx/rh/imagenes/findsmall.gif" ></a></cfif></td>
  </tr>
  <tr>
    <td class="fileLabel" nowrap><cf_translate key="FecNacExp" xmlFile="/rh/autogestion/autogestion.xml">Fecha de Nacimiento</cf_translate>:</td>
	<td><cf_locale name="date" value="#rsEmpleado.FechaNacimiento#"/></td>
  </tr>
  <tr>
    <td class="fileLabel" nowrap><cf_translate key="LB_Direccion" xmlFile="/rh/autogestion/autogestion.xml">Dirección</cf_translate>:</td>
	<td>#rsEmpleado.DEdireccion#</td>
  </tr>
<!---
  <tr>
    <td class="fileLabel" nowrap><cf_translate key="NDependietesExp">No. de Dependientes</cf_translate>:</td>
	<td>#rsEmpleado.DEcantdep#</td>
  </tr>
  <tr>
    <td class="fileLabel" nowrap><cf_translate key="BancoExp">Banco</cf_translate>:</td>
    <td>#rsEmpleado.Bdescripcion#</td>
  </tr>
  <tr>
    <td class="fileLabel" nowrap><cf_translate key="CuentaCExp">Cuenta Cliente</cf_translate>:</td>
	<td>#rsEmpleado.CBcc# (#rsEmpleado.Mnombre#)</td>
  </tr>
--->  
</table>
</cfoutput>
<script language="javascript" type="text/javascript">
	function Expediente(llave){
		location.href="../../expediente/consultas/expediente-globalcons.cfm?DEID="+ llave;
		
	}
</script>
