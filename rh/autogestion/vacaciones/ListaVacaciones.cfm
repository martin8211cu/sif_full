<title>
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Vacaciones"
		Default="Vacaciones"
		returnvariable="Titulo"/>
		<cfoutput>#Titulo#</cfoutput>
</title>

<cfif isdefined("url.DEid") and len(trim(url.DEid)) gt 0 and not isdefined("form.DEid")  >
	<cfset form.DEid = url.DEid>
</cfif>
<cfif isdefined("url.Fecha") and len(trim(url.Fecha)) gt 0 and not isdefined("form.Fecha")  >
	<cfset form.Fecha = url.Fecha>
</cfif>
<cfif  not isdefined("Session.cache_empresarial")>
	<cfset Session.cache_empresarial = 0>
</cfif>
<cfif  not isdefined("Session.Params.ModoDespliegue")>
	<cfset Session.Params.ModoDespliegue = 1>
</cfif>
<cf_templatecss>
<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">


<cfquery datasource="#Session.DSN#" name="rsEmpleado">
	select a.DEid,
		   a.Ecodigo,
		   a.Bid,
		   a.NTIcodigo, 
		   a.DEidentificacion, 
		   a.DEnombre, 
		   a.DEapellido1, 
		   a.DEapellido2, 
		   case a.DEsexo when 'M' then '<cf_translate key="LB_Masculino">Masculino</cf_translate>' 
						 when 'F' then '<cf_translate key="LB_Femenino">Femenino</cf_translate>' 
						 else 'N/D' 
		   end as Sexo,
		   a.CBTcodigo, 
		   a.DEcuenta, 
		   a.CBcc, 
		   a.DEdireccion, 
		   case a.DEcivil 
				when 0 then '<cf_translate key="LB_Soltero">Soltero(a)</cf_translate>' 
				when 1 then '<cf_translate key="LB_Casado">Casado(a)</cf_translate>' 
				when 2 then '<cf_translate key="LB_Divorciado">Divorciado(a)</cf_translate>' 
				when 3 then '<cf_translate key="LB_Viudo">Viudo(a)</cf_translate>' 
				when 4 then '<cf_translate key="LB_UnionLibre">Unión Libre</cf_translate>' 
				when 5 then '<cf_translate key="LB_Separado">Separado(a)</cf_translate>' 
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
		   a.Ulocalizacion, 
		   a.DEsistema, 
		   a.ts_rversion,
		   b.NTIdescripcion,
		   c.Mnombre,
		   coalesce(d.Bdescripcion, '<cf_translate key="LB_Ninguno">Ninguno</cf_translate>') as Bdescripcion	
	from DatosEmpleado a
		inner join NTipoIdentificacion b
			on a.NTIcodigo = b.NTIcodigo				
		inner join Monedas c
			on a.Mcodigo = c.Mcodigo
		left outer join Bancos d
			on a.Ecodigo = d.Ecodigo
			and a.Bid = d.Bid
	where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
</cfquery>
<table width="100%" cellpadding="3" cellspacing="0">
	<tr> 
	  <td>
	  	<cfinclude template="../../expediente/consultas/frame-infoEmpleado.cfm">
	  </td>
	</tr>
	<tr> 
	  <td class="<cfoutput>#Session.preferences.Skin#_thcenter</cfoutput>"><cf_translate key="LB_Vacaciones">Vacaciones</cf_translate></td>
	</tr>	
	<tr> 
	  <td>
			<cfif not isdefined("Form.DLlinea")>
				<cf_dbfunction name="to_char" args="a.DLlinea" returnvariable="LVDLlinea">
				<cf_dbfunction name="to_char" args="a.DEid" returnvariable="LVDEid">
				<cf_dbfunction name="to_char" args="a.RHTid" returnvariable="LVRHTid">
				<cf_dbfunction name="to_char" args="a.RHPid" returnvariable="LVRHPid">
				<cf_dbfunction name="to_char" args="a.DLconsecutivo" returnvariable="LVDLconsecutivo">
				<cf_dbfunction name="to_char" args="a.Dcodigo" returnvariable="LVDcodigo">
				<cf_dbfunction name="to_char" args="a.Ocodigo" returnvariable="LVOcodigo">
				<cf_dbfunction name="to_char" args="a.Tcodigo" returnvariable="LVTcodigo">
				<cf_dbfunction name="to_char" args="a.DLobs" returnvariable="LVDLobs">
				<cf_dbfunction name="to_char" args="b.RHTespecial" returnvariable="LVRHTespecial">
				<cf_dbfunction name="to_char" args="a.DLvdisf" returnvariable="LVDLvdisf">
				
				<cf_dbfunction name="to_char_integer" args="a.DLsalario" returnvariable="LVDLsalario">
				<cf_dbfunction name="date_format" args="a.DLfvigencia,DD/MM/YYYY" returnvariable="LVDLfvigencia">
				<cf_dbfunction name="date_format" args="a.DLffin,DD/MM/YYYY" returnvariable="LVDLffin">
				<cf_dbfunction name="date_format" args="a.DLfechaaplic,DD/MM/YYYY" returnvariable="LVDLfechaaplic">
				
				<!---Image Links--->
				<cf_dbfunction name="concat" args="'<a href=''javascript: reporte('|#LVDLlinea#|','|#LVDLconsecutivo#|','|#LVDEid#|','|#LVRHTid#|','|#LVDcodigo#|','|#LVOcodigo#|','|#LVRHPid#|','|'&quot;'|ltrim(rtrim(a.RHPcodigo))|'&quot;'|','|'&quot;'|ltrim(rtrim(a.Tcodigo))|'&quot;'|','|#LVDLfvigencia#|','|#LVDLffin#|','|'&quot;'|ltrim(rtrim(a.DLobs))|'&quot;'|','|#LVDLfechaaplic#|','|#LVRHTespecial#|','|#LVDLvdisf#|');''><img src=''/cfmx/rh/imagenes/findsmall.gif'' border=0></a>'" returnvariable="imprimir" delimiters="|">	
				
				<cf_dbfunction name="concat" args="'<a href=''javascript: VerVacaciones('|#LVDLlinea#|','|#LVDLconsecutivo#|','|#LVDEid#|','|#LVRHTid#|','|#LVDcodigo#|','|#LVOcodigo#|','|#LVRHPid#|','|'&quot;'|ltrim(rtrim(a.RHPcodigo))|'&quot;'|','|'&quot;'|ltrim(rtrim(a.Tcodigo))|'&quot;'|','|#LVDLfvigencia#|','|#LVDLffin#|','|'&quot;'|ltrim(rtrim(a.DLobs))|'&quot;'|','|#LVDLfechaaplic#|','|#LVRHTespecial#|','|#LVDLvdisf#|');''><img src=''/cfmx/rh/imagenes/iindex.gif'' border=''0''></a>'" returnvariable="editar" delimiters="|">
				
				
				<!---<cf_dbfunction name="to_char" args="'<a href=''javascript: void(0)''><img src=''/cfmx/rh/imagenes/findsmall.gif'' border=0></a>'" returnvariable="imprimir" delimiters="|">
				<cf_dbfunction name="to_char" args="'<a href=''javascript: void(0);''onClic=''javascript: alert(80)'' ><img src=''/cfmx/rh/imagenes/iindex.gif'' border=''0''></a>'" returnvariable="editar" delimiters="|">--->

				<!---<cfset imprimir = "''">
				<cfset editar = "''">	--->
				
				
				<!--- Expediente --->
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="FechaAplicacion"
					Default="Aplicacion"
					Idioma="#session.Idioma#"
					returnvariable="vAplicacion"/>
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="Acciones"
					Default="Acciones"
					Idioma="#session.Idioma#"
					returnvariable="vAccion"/>
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="Vigencia"
					Default="Vigencia"
					Idioma="#session.Idioma#"
					returnvariable="vVigencia"/>
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="HastaExp"
					Default="Finalizacion"
					Idioma="#session.Idioma#"
					returnvariable="vHasta"/>	
				<cfinvoke 
				 component="rh.Componentes.pListas"
				 method="pListaRH"
				 returnvariable="cantRegistros">
					<cfinvokeargument name="tabla" value="DLaboralesEmpleado a, RHTipoAccion b, RHPlazas c"/>
					<cfinvokeargument name="columnas" value="  #LVDLlinea#  as DLlinea, 
															   a.DLconsecutivo, 
															   #LVDEid# as DEid, 
															   #LVRHTid# as RHTid, 
															   a.Dcodigo, 
															   a.Ocodigo, 
															   #LVRHPid# as RHPid, 
															   a.RHPcodigo, 
															   a.Tcodigo,
															   a.DLfvigencia, 
															   a.DLffin,
															   case when a.DLfvigencia is not null then #LVDLfvigencia# else '' end as Vigencia,
															   case when a.DLffin is not null then #LVDLffin# else 'Indefinido' end as Finalizacion,
															   a.DLobs, 
															   #LVDLfechaaplic# as FechaAplicacion,
															   {fn concat(b.RHTcodigo ,{fn concat(' - ',b.RHTdesc)})} as Accion,
															   b.RHTespecial,
															   a.DLvdisf as DLvdisf,
															   #imprimir# as imprimir
															   ,case ( select  count(1)  from DLaboralesEmpleado x where x.DEid = a.DEid and x.DLfvigencia=a.DLfvigencia and x.DLffin = a.DLffin) when 0 then '' else #editar# end as editar "/>
					<cfinvokeargument name="desplegar" value="FechaAplicacion, Accion, Vigencia, Finalizacion, DLvdisf, imprimir, editar"/>
					<cfinvokeargument name="etiquetas" value="#vAplicacion#, #vAccion#, #vVigencia#, #vHasta#, Dias Disf, , "/>
					<cfinvokeargument name="formatos" value="V,V,V,V,V,V,V"/>
					<cfinvokeargument name="filtro" value="a.DEid = #form.DEid#
															and a.RHTid = b.RHTid
															and a.RHPid = c.RHPid
															and b.RHTcomportam = 3
															and ( a.DLfvigencia >= '#form.Fecha#'   or '#form.Fecha#'  between  a.DLfvigencia and a.DLffin )
															order by a.DLfechaaplic desc, a.DLfvigencia, a.DLffin, a.DLconsecutivo"/>
					<cfinvokeargument name="align" value="center, left, center, center, center, center, center"/>
						
					<cfinvokeargument name="showLink" value="False"/>
					<cfinvokeargument name="formName" value="FormVacaciones"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="irA" value="ListaVacaciones.cfm"/>
					<cfinvokeargument name="debug" value="N"/>
				</cfinvoke>
			<cfelse>
				<cfinclude template="../../expediente/consultas/frame-detalleAcciones.cfm">
			</cfif>	
	  </td>
	</tr>	

</table>

<script language="javascript" type="text/javascript">
	function reporte(DLlinea,DLconsecutivo, DEid, RHTid,Dcodigo,Ocodigo,RHPid, RHPcodigo, Tcodigo, DLfvigencia, DLffin, DLobs,FechaAplicacion,RHTespecial,DLvdisf){
		var form = document.getElementById('FormVacaciones');
		 form.DLLINEA.value=DLlinea;
		 form.DLCONSECUTIVO.value=DLconsecutivo;
		 form.DEID.value=DEid;
		 form.RHTID.value=RHTid;
		 form.DCODIGO.value=Dcodigo;
		 form.OCODIGO.value=Ocodigo;
		 form.RHPID.value=RHPid;
		 form.RHPCODIGO.value=RHPcodigo;
		 form.TCODIGO.value=Tcodigo;
		 form.DLFVIGENCIA.value=DLfvigencia;
		 form.DLFFIN.value=DLffin;
		 form.DLOBS.value=DLobs;
		 form.FECHAAPLICACION.value=FechaAplicacion;
		 form.RHTESPECIAL.value=RHTespecial;
		 form.DLVDISF.value=DLvdisf;
		 form.action = 'ListaVacaciones.cfm'
		 form.submit();
		 
		<!---<cfif form.tipo eq 'auto'>
			 var PARAM  = "/cfmx/rh/evaluaciondes/consultas/evaluacion-respuestas.cfm?Cual=A&RHEEid="+ RHEEid + "&DEid=" + DEid
		<cfelse>
			 var PARAM  = "/cfmx/rh/evaluaciondes/consultas/evaluacion-respuestas.cfm?Cual=J&RHEEid="+ RHEEid + "&DEid=" + DEid
		</cfif> 
		open(PARAM,'','left=100,top=150,scrollbars=yes,resizable=yes,width=800,height=400')  --->
	}
	
	function VerVacaciones(DLlinea,DLconsecutivo, DEid, RHTid,Dcodigo,Ocodigo,RHPid, RHPcodigo, Tcodigo, DLfvigencia, DLffin, DLobs,FechaAplicacion,RHTespecial,DLvdisf){
		var form = document.getElementById('FormVacaciones');
		 form.DLLINEA.value=DLlinea;
		 form.DLCONSECUTIVO.value=DLconsecutivo;
		 form.DEID.value=DEid;
		 form.RHTID.value=RHTid;
		 form.DCODIGO.value=Dcodigo;
		 form.OCODIGO.value=Ocodigo;
		 form.RHPID.value=RHPid;
		 form.RHPCODIGO.value=RHPcodigo;
		 form.TCODIGO.value=Tcodigo;
		 form.DLFVIGENCIA.value=DLfvigencia;
		 form.DLFFIN.value=DLffin;
		 form.DLOBS.value=DLobs;
		 form.FECHAAPLICACION.value=FechaAplicacion;
		 form.RHTESPECIAL.value=RHTespecial;
		 form.DLVDISF.value=DLvdisf;
		 form.action = '../../expediente/consultas/frame-vacaciones-vista.cfm'
		 form.submit();
	}
</script>	


