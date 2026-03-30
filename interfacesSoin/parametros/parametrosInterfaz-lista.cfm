<cf_dbfunction name="op_concat" returnvariable="_cat">
<cf_dbfunction name="mod" args="MinutosRetardo,60" returnvariable="Mod60_MinRetardo">
<cfquery name="rsQuery" datasource="sifinterfaces">
	select NumeroInterfaz, Descripcion, OrigenInterfaz, TipoProcesamiento,
		Componente, Activa, FechaActivacion, FechaActividad, 
		NumeroEjecuciones, Ejecutando
		, case Activa when 1 then 'Activa' else 'Inactiva' end as ActivaDescripcion
		, case 
			when TipoProcesamiento = 'A' then
				case  
					when TipoRetardo = 'M' AND coalesce(MinutosRetardo,0) = 0 
						then 'inmediato'
					when TipoRetardo = 'M' 
						then <cf_dbfunction name="to_char" args="coalesce(MinutosRetardo,0)"> #_cat# ' min.'
					when TipoRetardo = 'H' 
						then 'a ' #_cat# <cf_dbfunction name="to_char" args="MinutosRetardo / 60"> #_cat# ':' #_cat# right('00' #_cat# <cf_dbfunction name="to_char" args="#Mod60_MinRetardo#">,2)
				end
		  end as MinutosRetardo
		, case OrigenInterfaz 
			when 'S' then 'SOIN-SIF' 
			else <cfif findNoCase("SOIN",Request.CEnombre)>'EXTERNO'<cfelse>'#Ucase(Request.CEnombre)#'</cfif>
		  end as OrigenInterfazDescripcion
		, case TipoProcesamiento 
			when 'S' then 'Sincrónico' 
			when 'D' then 'Sincr.Directo' 
			when 'A' then 'Asincrónico'
			else '?????'
		  end as TipoProcesamientoDescripcion
		, case ManejoDatos 
			when 'T' then 'Tablas' 
			when 'V' then 'Variables' 
			else '?????'
		  end as ManejoDatosDescripcion
		, case  
			when TipoProcesamiento <> 'A' then ''
			when spFinalTipo = 'N' then 'No' 
			when spFinalTipo = 'D' then 'Dflt' 
			when spFinalTipo = 'C' then 'CF' 
			when spFinalTipo = 'S' then 'SP' 
			else '?????'
		  end as spFinalTipo
	from Interfaz
	order by NumeroInterfaz
</cfquery>
<cfinvoke 
 component="sif.Componentes.pListas"
 method="pListaQuery"
 returnvariable="pListaRet">
	<cfinvokeargument name="query" value="#rsQuery#"/>
	<cfinvokeargument name="usaAjax"	value="no"/>

	<cfinvokeargument name="cortes" value=""/>
	<cfinvokeargument name="desplegar" value="NumeroInterfaz, Descripcion, OrigenInterfazDescripcion, TipoProcesamientoDescripcion,ManejoDatosDescripcion,ActivaDescripcion,MinutosRetardo,spFinalTipo"/>
	<cfinvokeargument name="etiquetas" value="Número<BR>Interfaz, Descripción, Origen, Tipo<BR>Procesamiento,Manejo<BR>Datos,Estado<BR>Interfaz,Tiempo<BR>Retardo,Tipo<br>spFinal"/>
	<cfinvokeargument name="formatos" value="S,S,S,S,S,S,S,S"/>
	<cfinvokeargument name="ajustar" value="N,N,N,N,N,N,N,N"/>
	<cfinvokeargument name="align" value="left,left,left,center,center,left,center,center"/>
	<cfinvokeargument name="lineaRoja" value="Activa EQ 0"/>
	<cfinvokeargument name="checkboxes" value="N"/>
	<cfinvokeargument name="irA" value="#GetFileFromPath(GetTemplatePath())#"/>
	<cfinvokeargument name="MaxRows" value="20"/>
	<cfinvokeargument name="formName" value="frmListaParams"/>
	<cfinvokeargument name="PageIndex" value="1"/>
	<cfinvokeargument name="showLink" value="true"/>
	<cfinvokeargument name="showEmptyListMsg" value="True"/>
	<cfinvokeargument name="EmptyListMsg" value="No existen Interfaces Definidas"/>
	<cfinvokeargument name="Keys" value="NumeroInterfaz"/>
</cfinvoke>
