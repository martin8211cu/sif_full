<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_PeriodoPresupuestario" 	default="Periodo Presupuestario" 
returnvariable="LB_PeriodoPresupuestario" xmlfile="ListaPeriodosPresupuestales.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Estado" 	default="Estado" 
returnvariable="LB_Estado" xmlfile="ListaPeriodosPresupuestales.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Versiones" 	default="Versiones" 
returnvariable="LB_Versiones" xmlfile="ListaPeriodosPresupuestales.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Seleccionadas" 	default="Seleccionadas" 
returnvariable="LB_Seleccionadas" xmlfile="ListaPeriodosPresupuestales.xml"/>
<cf_dbfunction name="OP_concat"	returnvariable="_Cat">

<cfquery name="PeriodosPresupuestable" datasource="#session.dsn#">
	select  #data.ANFid# as AFNid, CPPid, 
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
			#_Cat# ' ' #_Cat# <cf_dbfunction name="date_format" args="CPPfechaHasta,YYYY">  as CPPdescripcion,
		case CPPestado 
			when 0 then 'Inactivo' 
			when 1 then 'Abierto' 
			when 2 then 'Cerrado' 
			when 5 then 'Sin Presupuesto' 
			end as Estado
		, (
			select count(1)
			  from ANformulacionVersion 
			 where ANFid = #data.ANFid#
			   and CPPid = CPresupuestoPeriodo.CPPid
		) as cantidad
		from CPresupuestoPeriodo
		where Ecodigo = #session.Ecodigo#
	order by CPPfechaDesde desc
</cfquery>

<cfinvoke component="sif.Componentes.pListas" method="pListaQuery">
	<cfinvokeargument name="query" 			  value="#PeriodosPresupuestable#"/>
	<cfinvokeargument name="desplegar"  	  value="CPPdescripcion,Estado,Cantidad"/>
	<cfinvokeargument name="etiquetas"  	  value="#LB_PeriodoPresupuestario#,#LB_Estado#,#LB_Versiones#<BR>#LB_Seleccionadas#"/>
	<cfinvokeargument name="formatos"   	  value="S,S,I"/>
	<cfinvokeargument name="align" 			  value="left,left,center"/>
	<cfinvokeargument name="ajustar"   		  value="N"/>
    <cfinvokeargument name="funcion"   		  value="popup"/>
	<cfinvokeargument name="fparams"   		  value="CPPid, AFNid"/>
	<cfinvokeargument name="showEmptyListMsg" value="true"/>
	<cfinvokeargument name="keys"             value="CPPid"/>
	<cfinvokeargument name="showEmptyListMsg" value="true"/>
	<cfinvokeargument name="formName" 		  value="ListaPeriodosPre"/>	

	<cfinvokeargument name="lineaVerde"       value="Cantidad GT 0"/>
</cfinvoke>
<script language="javascript" type="text/javascript">
	function popup(CPPid,ANFid )
	{
		var PARAM  = "PopUp_ANformulacionVersion.cfm?CPPid="+CPPid+"&ANFid="+ANFid;
		window.open(PARAM,'','left=250,top=250,scrollbars=yes,resizable=yes,width=700,height=580');
	}
</script>		