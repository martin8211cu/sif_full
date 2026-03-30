<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Titulo" 	default="Versiones por Período en la Formulaci&oacute;n de Presupuesto" returnvariable="LB_Titulo" xmlfile="PopUp_ANformulacionVersion.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Formulacion" 	default="Formulaci&oacute;n" 
returnvariable="LB_Formulacion" xmlfile="PopUp_ANformulacionVersion.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_PeriodoPresupuestario" 	default="Per&iacute;odo Presupuestario" 
returnvariable="LB_PeriodoPresupuestario" xmlfile="PopUp_ANformulacionVersion.xml"/>

<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Titulo#'>
<cf_dbfunction name="OP_concat"	returnvariable="_Cat">

<cfquery name="rsFormulacion" datasource="#session.dsn#">
	select ANFcodigo, ANFdescripcion
	  from ANformulacion
	 where ANFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ANFid#">
</cfquery>
<cfquery name="rsPeriodo" datasource="#session.dsn#">
	select 
		case CPPtipoPeriodo 
			when 1 then 'Mensual' 
			when 2 then 'Bimestral' 
			when 3 then 'Trimestral' 
			when 4 then 'Cuatrimestral' 
			when 6 then 'Semestral' 
			when 12 then 'Anual' else '' end
			#_Cat# ' de ' #_Cat# 
       case <cf_dbfunction name="date_part" args="MM,CPPfechaDesde">
	        when 1 then 'Enero' 
			when 2 then 'Febrero' 
			when 3 then 'Marzo' 
			when 4 then 'Abril' 
			when 5 then 'Mayo' 
			when 6 then 'Junio' 
			when 7 then 'Julio' 
			when 8 then 'Agosto' 
			when 9 then 'Setiembre' 
			when 10 then 'Octubre' 
			when 11 then 'Noviembre' 
			when 12 then 'Diciembre' else '' end
			#_Cat# ' ' #_Cat# 
		case 
			when <cf_dbfunction name="date_format" args="CPPfechaDesde,YYYY"> <> <cf_dbfunction name="date_format" args="CPPfechaHasta,YYYY"> 
			then <cf_dbfunction name="date_format" args="CPPfechaDesde,YYYY">
		end
			#_Cat# ' a ' #_Cat# 
		case <cf_dbfunction name="date_part" args="MM,CPPfechaHasta">
			when 1 then 'Enero' 
			when 2 then 'Febrero' 
			when 3 then 'Marzo' 
			when 4 then 'Abril' 
			when 5 then 'Mayo' 
			when 6 then 'Junio' 
			when 7 then 'Julio' 
			when 8 then 'Agosto' 
			when 9 then 'Setiembre' 
			when 10 then 'Octubre' 
			when 11 then 'Noviembre' 
			when 12 then 'Diciembre' else '' end
			#_Cat# ' ' #_Cat# <cf_dbfunction name="date_format" args="CPPfechaHasta,YYYY">  as CPPdescripcion
		from CPresupuestoPeriodo
		where Ecodigo = #session.Ecodigo#
		  and CPPid		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CPPid#">
</cfquery>
<cfoutput>
<table>
	<tr>
		<td>
			<strong>#LB_Formulacion#:</strong>&nbsp;	
		</td>
		<td>
			#rsFormulacion.ANFcodigo# - #rsFormulacion.ANFdescripcion#
		</td>
	</tr>
	<tr>
		<td>
			<strong>#LB_PeriodoPresupuestario#:</strong>&nbsp;
		</td>
		<td>
			#rsPeriodo.CPPdescripcion#
		</td>
	</tr>
</table>
</cfoutput>
<cfquery name="versionesP" datasource="#session.dsn#">
	select	v.CVid,
			CVdescripcion,
			case
				when CVaprobada=1 then 'Aplicada'
				when CVestado = 0 then 'Solicitud Base'
				when CVestado = 1 then 'Solicitando Usuarios'
				when CVestado = 2 then 'Ajuste Final'
			end as Estado,
			case CVtipo 
				when '1' then 'Presupuesto Ordinario' 
				when '2' then 'Modificación Presupuestaria' 
				end as Tipo,
			fv.CVid as Incluido
		from CVersion v
			left join ANformulacionVersion fv
				on fv.ANFid = #url.ANFid#
				and fv.CPPid = v.CPPid
				and fv.CVid  = v.CVid
		where v.Ecodigo = #session.Ecodigo#
		 and v.CPPid   = #url.CPPid#
</cfquery>
<iframe name="fr" id="fr" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto"></iframe>

<cfinvoke component="sif.Componentes.pListas" method="pListaQuery">
	<cfinvokeargument name="query" 			  value="#versionesP#"/>
	<cfinvokeargument name="desplegar"  	  value="CVdescripcion,Estado, Tipo"/>
	<cfinvokeargument name="etiquetas"  	  value="Descripción,Estado, Tipo"/>
	<cfinvokeargument name="formatos"   	  value="S,S, S, I"/>
	<cfinvokeargument name="align" 			  value="left,left,left,left"/>
	<cfinvokeargument name="ajustar"   		  value="N"/>
	<cfinvokeargument name="irA"              value=""/>
	<cfinvokeargument name="showEmptyListMsg" value="true"/>
	<cfinvokeargument name="keys"             value="CVid"/>
	<cfinvokeargument name="showEmptyListMsg" value="true"/>
	<cfinvokeargument name="mostrar_filtro"   value="true"/>
	<cfinvokeargument name="formName" 		  value="versionesP"/>	
	<cfinvokeargument name="checkboxes" 	  value="S"/>	 
	<cfinvokeargument name="checkedcol" 	  value="Incluido"/>	
	<cfinvokeargument name="MaxRows" 	      value="13"/>	
	<cfinvokeargument name="checkbox_function"value="fnguardarVersion(this)"/>	
</cfinvoke>
	<table align="center">
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr>
			<td colspan="2" align="center"><input type="button" name="btnclose" class="btnNormal" value="Cerrar" onClick="javascript:window.close()"></td>
		</tr>
	</table>
<script language="javascript" type="text/javascript">
	function fnguardarVersion(m){
	<cfoutput>
		document.getElementById('fr').src='PopUp_ANformulacionVersion-sql.cfm?CVid='+m.value+'&guardar='+m.checked+'&ANFid='+#url.ANFid#+'&CPPid='+#url.CPPid#;
	</cfoutput>
	window.opener.document.form1.action="";
	window.opener.document.form1.submit();
	}
</script>
<cf_web_portlet_end>
