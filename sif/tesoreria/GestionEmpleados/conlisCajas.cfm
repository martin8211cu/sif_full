<cfparam name="Attributes.modo"		default="" 		type="String">
<cfparam name="Attributes.form"		default="form1" type="String">
<cfparam name="Attributes.value"	default="" 		type="String">
<cfparam name="Attributes.CFid"		default="" 		type="any">
<cfparam name="Attributes.Mcodigo"	default="" 		type="any">
<cfparam name="Attributes.lectu"	default="no" type="boolean">
<cfparam name="Attributes.Responsable"	default="" 		type="any">

<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_ListaCajas" default = "Lista de Cajas" returnvariable="LB_ListaCajas" xmlfile = "ConlisCajas.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Codigo" default = "C&oacute;digo" returnvariable="LB_Codigo" xmlfile = "ConlisCajas.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Descripcion" default = "Descripci&oacute;n" returnvariable="LB_Descripcion" xmlfile = "ConlisCajas.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_CAJASCHICASPARAGASTOSMENORES" default = "CAJAS CHICAS PARA GASTOS MENORES" returnvariable="LB_CAJASCHICASPARAGASTOSMENORES" xmlfile = "ConlisCajas.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_CAJASESPECIALESDEEFECTIVO" default = "CAJAS ESPECIALES DE EFECTIVO" returnvariable="LB_CAJASESPECIALESDEEFECTIVO" xmlfile = "ConlisCajas.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_CAJASEXTERNAS" default = "CAJAS EXTERNAS" returnvariable="LB_CAJASEXTERNAS" xmlfile = "ConlisCajas.xml">

<cfset LvarModificable=''>
<cfif isdefined ('Attributes.modo') and Attributes.modo eq 'ALTA'>
	<cfset LvarModificable = 'S'>
</cfif>

<cfif isdefined ('Attributes.modo') and Attributes.modo eq 'CAMBIO'>
	<cfset LvarModificable = 'N'>
</cfif>

<cfif isdefined ('Attributes.value') and len(trim(Attributes.value)) gt 0>
	<cfset LvarCCHid=#Attributes.value#>
<cfelse>
	<cfset LvarCCHid=''>
</cfif>

<cfif isdefined ('Attributes.Mcodigo') and len(trim(Attributes.Mcodigo)) gt 0> 
	<cfset LvarM='and Mcodigo=#Attributes.Mcodigo#'>
<cfelse>
	<cfset LvarM=''>
</cfif>

<cfif isdefined ('Attributes.Responsable') and len(trim(Attributes.Responsable)) gt 0> 
	<cfset LvarRes='and CCHresponsable=#Attributes.Responsable#'>
<cfelse>
	<cfset LvarRes=''>
</cfif>


<cfquery name="rsCajas" datasource="#session.dsn#">
	select CCHid,CCHcodigo,CCHdescripcion,CCHtipo,
			case CCHtipo
				when 1 then '#LB_CAJASCHICASPARAGASTOSMENORES#'
				when 2 then '#LB_CAJASESPECIALESDEEFECTIVO#'
				when 3 then '#LB_CAJASEXTERNAS#'
			end as CORTE
	  from CCHica 
	 where Ecodigo=#session.Ecodigo#
	   and CCHtipo in (1,2)
	 order by CCHtipo, CCHcodigo
</cfquery>
<cfquery name="rsSQL" dbtype="query">
	select distinct CCHtipo
	  from rsCajas
</cfquery>

		
<cf_conlis  title="#LB_ListaCajas#"
			campos = "CCHid, CCHcodigo, CCHdescripcion" 
			desplegables = "N,S,S" 
			modificables = "N,S,N" 
			size = "0,15,34"
			asignar="CCHid, CCHcodigo, CCHdescripcion, CCHtipo"
			cortes="CORTE"
			asignarformatos="S,S,S"
			tabla="CCHica"
			columnas="CCHid, CCHcodigo, CCHdescripcion, CCHtipo,
						case CCHtipo
							when 1 then '#LB_CAJASCHICASPARAGASTOSMENORES#'
							when 2 then '#LB_CAJASESPECIALESDEEFECTIVO#'
							when 3 then '#LB_CAJASEXTERNAS#'
						end as CORTE
					"
			filtro="Ecodigo = #Session.Ecodigo# and CCHestado='ACTIVA' and CCHtipo in (1,2) #LvarM# #LvarRes# order by CCHtipo, CCHcodigo"
			desplegar=" CCHcodigo, CCHdescripcion"
			etiquetas=" #LB_Codigo#, #LB_Descripcion#"
			formatos="S,S"
			align="left,left"
			showEmptyListMsg="true"
			EmptyListMsg=""
			form="#Attributes.form#"
			width="800"
			height="500"
			left="70"
			top="20"
			filtrar_por="CCHcodigo, CCHdescripcion"
			index="1"		
			traerInicial="#LvarCCHid NEQ ''#"	
			traerFiltro="CCHid=#LvarCCHid#"
			funcion="funcCambiaValores"
			fparams="CCHid"
			readOnly="#Attributes.lectu#"
/>        
