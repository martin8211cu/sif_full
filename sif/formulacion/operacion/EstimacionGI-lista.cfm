<cfset filtro = ''>
<cfset botones = ''>
<cfif not request.RolAdmin>
	<cfinvoke component="sif.Componentes.FP_SeguridadUsuario" method="fnGetCFs" returnvariable="CFuncionales" Usucodigo="#session.Usucodigo#"></cfinvoke>
	<cfif CFuncionales.recordcount eq 0>
		<cfset filtro = 'and a.CFid in(-1)'>
	<cfelse>
		<cfset filtro = 'and a.CFid in(#valuelist(CFuncionales.CFid)#)'>
	</cfif>
<cfelse>
	<cfset botones = 'Nuevo'>
</cfif>
<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<cf_dbfunction name="to_char" args="{fn year(CPPfechaDesde)}" returnvariable="CPPfechaDesde">
<cf_dbfunction name="to_char" args="{fn year(CPPfechaHasta)}" returnvariable="CPPfechaHasta">
<cfquery name="rsEstados" datasource="#session.DSN#">
	select distinct EP.FPEEestado as value, case EP.FPEEestado 
						  when 0 then 'En Preparación' 
						  when 1 then 'En Aprobación' 
						  when 2 then 'En Equilibrio Financiero' 
						  when 3 then 'En Aprobación Interna' 
						  when 4 then 'En Aprobación Externa' 
						  when 5 then 'Aprobada' 
						  when 6 then 'Rechazada' 
						  else 'otro' end as description
	from FPEEstimacion EP
		inner join TipoVariacionPres TV
			on TV.FPTVid = TV.FPTVid
	where EP.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	and TV.FPTVTipo = -1
	and EP.FPEEestado in (0,1,2,3,4,5,6) 
	union 
	select -1 as value, '-- todos --' as description from dual
	order by 1
</cfquery>
<cfquery name="rsPeriodos" datasource="#session.DSN#">
	select distinct a.CPPid as value,  case b.CPPtipoPeriodo when 1 then 'Mensual' when 2 then 'Bimestral' when 3 then 'Trimestral' when 4 then 'Cuatrimestral' when 6 then 'Semestral' when 12 then 'Anual' else '' end
							#_Cat# ' de ' #_Cat# 
						 case {fn month(CPPfechaDesde)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
							#_Cat# ' ' #_Cat# #preservesinglequotes(CPPfechaDesde)#
							#_Cat# ' a ' #_Cat# 
						 case {fn month(CPPfechaHasta)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
							#_Cat# ' ' #_Cat# #preservesinglequotes(CPPfechaHasta)#
						 as description, 1 as ord 
	from FPEEstimacion a 
		inner join CPresupuestoPeriodo b 
			on a.Ecodigo = b.Ecodigo 
		   and a.CPPid   = b.CPPid
		inner join TipoVariacionPres TV
			on TV.FPTVid = a.FPTVid
	where a.Ecodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	  and TV.FPTVTipo = -1 
	  and FPEEestado in (0,1,2,3,4,5,6)
	union 
	select -1 as value, '-- todos --' as description, 0 as ord  from dual
	order by ord,description
</cfquery>
<cfinvoke component="sif.Componentes.pListas"
		method			="pLista"
		returnvariable	="Lvar_Lista"
		tabla			="FPEEstimacion a inner join CPresupuestoPeriodo b on a.Ecodigo = b.Ecodigo and a.CPPid  = b.CPPid  inner join CFuncional c on c.CFid = a.CFid inner join TipoVariacionPres TV on TV.FPTVid = a.FPTVid"
		columnas		="FPEEid,
						 case b.CPPtipoPeriodo when 1 then 'Mensual' when 2 then 'Bimestral' when 3 then 'Trimestral' when 4 then 'Cuatrimestral' when 6 then 'Semestral' when 12 then 'Anual' else '' end
							#_Cat# ' de ' #_Cat# 
						 case {fn month(CPPfechaDesde)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
							#_Cat# ' ' #_Cat# #CPPfechaDesde#
							#_Cat# ' a ' #_Cat# 
						 case {fn month(CPPfechaHasta)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
							#_Cat# ' ' #_Cat# #CPPfechaHasta#
							#_Cat# ' / Presupuesto Ordinario'
						 as Pdescripcion,CFcodigo #_Cat# ' - ' #_Cat# CFdescripcion as CF, 
						  case FPEEestado 
						  when 0 then 'En Preparación' 
						  when 1 then 'En Aprobación' 
						  when 2 then 'En Equilibrio Financiero' 
						  when 3 then 'En Aprobación Interna' 
						  when 4 then 'En Aprobación Externa' 
						  when 5 then 'Aprobada' 
						  when 6 then 'Publicada'
						  when 7 then 'Descartada'
						  else 'otro' end as Estado
						  ,a.CPPid,c.CFid,FPEEestado"
		desplegar		="Pdescripcion,CF,Estado"
		etiquetas		="Periodo, Código/Descripción Centro Funcional, Estado"
		formatos		="S,S,S"
		filtro			="a.Ecodigo = #session.Ecodigo# and TV.FPTVTipo = -1 and a.FPEEestado in (0,1,2,3,4,5) #filtro#  and b.CPPestado in(0,1) order by b.CPPfechaDesde, c.CFcodigo"
		incluyeform		="true"
		align			="left,left,left"
		keys			="FPEEid"
		maxrows			="25"
		showlink		="true"
		formname		="formEstimacion"
		ira				="#CurrentPage#"
		showEmptyListMsg="true"
		botones         ="#botones#"
		cortes			="Pdescripcion"
		filtrar_automatico ="true"
		mostrar_filtro 	="true"
		filtrar_por		="a.CPPid,CFcodigo #_Cat# ' - ' #_Cat# CFdescripcion,FPEEestado"
		rsPdescripcion	="#rsPeriodos#"
		rsEstado	="#rsEstados#"/>
<cfif request.RolAdmin>
<script type="text/javascript">
	
	var popup_win = false;
	
	function funcNuevo(){
		if(popup_win){
			if(!popup_win.closed)
				popup_win.close();
		}
		var PARAM  = "EstimacionGI-popUp.cfm?RolAdmin=<cfoutput>#request.RolAdmin#</cfoutput>";
		popup_win = open(PARAM,'','left=250,top=250,scrollbars=yes,resizable=yes,width=400,height=300');
		return false;
	}
</script>
</cfif>
