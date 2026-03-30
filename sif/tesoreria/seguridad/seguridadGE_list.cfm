<cfinvoke key="LB_Nombre" default="Nombre"	returnvariable="LB_Nombre"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="seguridadGE_list.xml"/>
<cfinvoke key="LB_Usuario" default="Usuario"	returnvariable="LB_Usuario"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="seguridadGE_list.xml"/>
<cfinvoke key="LB_Solicitante" default="Solicitante"	returnvariable="LB_Solicitante"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="seguridadGE_list.xml"/>
<cfinvoke key="LB_Aprobador" default="Aprobador"	returnvariable="LB_Aprobador"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="seguridadGE_list.xml"/>
<cfinvoke key="LB_MontoMaximo" default="Monto M&aacute;aximo"	returnvariable="LB_MontoMaximo"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="seguridadGE_list.xml"/>
<cfinvoke key="LB_aAprobar" default="a Aprobar"	returnvariable="LB_aAprobar"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="seguridadGE_list.xml"/>
<cfinvoke key="LB_PuedeCambiar" default="Puede Cambiar"	returnvariable="LB_PuedeCambiar"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="seguridadGE_list.xml"/>
<cfinvoke key="LB_Tesoreria" default="Tesoreria"	returnvariable="LB_Tesoreria"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="seguridadGE_list.xml"/>


<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<form name="formList" method="post" action="seguridadGE.cfm">
	<table width="100%" cellpadding="0" cellspacing="0" border="0">
		<tr>
			<td nowrap="nowrap" class="tituloListas">
				<strong><cf_translate key=LB_CentroFuncional>Centro Funcional</cf_translate>:</strong>
			</td>

			<td class="tituloListas">
				<cf_navegacion name="filtro_CFid" default="-1" session>
				<cfif form.filtro_CFid EQ "">
					<cfset form.filtro_CFid = -1>
				</cfif>
				<cfquery name="rsFiltro_CFid" datasource="#session.DSN#">
					select CFid as filtro_CFid, CFcodigo as filtro_CFcodigo, CFdescripcion as filtro_CFdescripcion
					  from CFuncional
					 where CFid = #form.filtro_CFid#
				</cfquery>
				<cf_rhcfuncional 
					form="formList" 
					id="filtro_CFid"
					name="filtro_CFcodigo"
					desc="filtro_CFdescripcion" 
					query="#rsFiltro_CFid#"
					titulo="Seleccione el Centro Funcional" 
					size="40" excluir="-1" tabindex="1"
				>
				<cfif form.filtro_CFid NEQ "-1">
					<cfset LvarFiltro_CF = "and tu.CFid = #form.filtro_CFid#">
				<cfelse>
					<cfset LvarFiltro_CF = "">
				</cfif>
			</td>
			<td width="1000" class="tituloListas">
				&nbsp;&nbsp;&nbsp;
			</td>
		</tr>
	</table>
	<cfset LvarImgChecked  	 = "<img border=""0"" src=""/cfmx/sif/imagenes/checked.gif"">">
	<cfset LvarImgUnchecked	 = "<img border=""0"" src=""/cfmx/sif/imagenes/unchecked.gif"">">
	<cfquery name="rsSiNo" datasource="#session.DSN#">
		select -1 as value, '' as description, 1 as orden from dual
		UNION
		select 1 as value, 'Si' as description, 2 as orden from dual
		UNION
		select 0 as value, 'No' as description, 3 as orden from dual
		order by orden
	</cfquery>
	<cfinvoke component="sif.Componentes.pListas" method="pLista"
		tabla="
				TESusuarioGE tu
					inner join Usuario u
						inner join DatosPersonales dp
						   on dp.datos_personales = u.datos_personales
						on u.Usucodigo = tu.Usucodigo
					inner join CFuncional cf
						on cf.CFid = tu.CFid
				"
		columnas="
				  tu.CFid, tu.Usucodigo
				
				, cf.CFcodigo #LvarCNCT# ' - ' #LvarCNCT# cf.CFdescripcion as CentroFuncional
				, u.Usulogin
				, dp.Pnombre #LvarCNCT# ' ' #LvarCNCT# dp.Papellido1 #LvarCNCT# ' ' #LvarCNCT# dp.Papellido2 as Usuario
				, case
					when tu.TESUGEsolicitante = 1 
						then '#PreserveSingleQuotes(LvarImgChecked)#'
						else '#PreserveSingleQuotes(LvarImgUnChecked)#'
				  end as Solicitante
				, case
					when tu.TESUGEaprobador = 1 
						then '#PreserveSingleQuotes(LvarImgChecked)#'
						else '#PreserveSingleQuotes(LvarImgUnChecked)#'
				  end as Aprobador
				, tu.TESUGEmontoMax as montoMaximo
				, case 
					when tu.TESUGEcambiarTES = 1 
						then '#PreserveSingleQuotes(LvarImgChecked)#'
						else '#PreserveSingleQuotes(LvarImgUnChecked)#'
				  end as CambiarTES
			"
		filtro="tu.Ecodigo = #session.Ecodigo# #LvarFiltro_CF# order by cf.CFcodigo, u.Usulogin"
		cortes="CentroFuncional"
		desplegar="Usulogin, Usuario, Solicitante, Aprobador, montoMaximo, CambiarTES"
		etiquetas="#LB_Usuario#, #LB_Nombre#, #LB_Solicitante#, #LB_Aprobador#, #LB_MontoMaximo#<BR>#LB_aAprobar#, #LB_PuedeCambiar#<BR>#LB_Tesoreria#"
		formatos="S,S,S,S,M,S"
		align="left,left,center,center,right,center"
		ira="seguridadGE.cfm"
		form_method="post"
		keys="CFid,Usulogin"
		showLink="yes"
		incluyeForm="no"
		formName="formList"
	
		mostrar_filtro="yes"
		filtrar_automatico="yes"
		filtrar_Por="Usulogin, dp.Pnombre #LvarCNCT# ' ' #LvarCNCT# dp.Papellido1 #LvarCNCT# ' ' #LvarCNCT# dp.Papellido2, TESUGEsolicitante, TESUGEaprobador, TESUGEmontoMax, TESUGEcambiarTES"
		rsSolicitante="#rsSINO#"
		rsAprobador="#rsSINO#"
		rsCambiarTES="#rsSINO#"
	
		botones="Nuevo"
	/>
</form>