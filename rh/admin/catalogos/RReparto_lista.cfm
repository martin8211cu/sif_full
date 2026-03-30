<cfquery name="rsSQL" datasource="#session.dsn#">
	select ERRdesde,ERRhasta,ERRestado,ERRid,
	case when ERRestado = 1
		then 'Aplicado'
	else
		'En Proceso'
	end as Estado
		from ERegimenReparto
	where Ecodigo = #session.Ecodigo#
</cfquery>
	
<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
	query="#rsSQL#"
	desplegar="ERRdesde,ERRhasta,Estado"
	etiquetas="Fecha Desde,Fecha Hasta, Estado"
	formatos="D,D,S"
	align="left,left,left"
	ira="RReparto.cfm"
	showEmptyListMsg="yes"
	keys="ERRid"	
	MaxRows="10"
	navegacion=""	
	incluyeForm="true"
	PageIndex="1">
			