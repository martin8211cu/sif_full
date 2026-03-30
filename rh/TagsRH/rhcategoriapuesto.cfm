<cfset def = QueryNew('dato')>

<cfparam name="Attributes.form" 				default="form1" 			type="String">		<!--- Nombre del form donde se colocará el campo --->
<cfparam name="Attributes.query" 				default="#def#" 			type="query">		<!--- consulta por defecto --->
<cfparam name="Attributes.tablaReadonly" 		default="false" 			type="boolean">		<!--- indica si se accede en forma lectura --->
<cfparam name="Attributes.categoriaReadonly"	default="false" 			type="boolean">		<!--- indica si se accede en forma lectura --->
<cfparam name="Attributes.puestoReadonly"		default="false" 			type="boolean">		<!--- indica si se accede en forma lectura --->
<cfparam name="Attributes.showTablaSalarial" 	default="true" 				type="boolean">		<!--- indica si se muestra la fila de tabla Salarial --->
<cfparam name="Attributes.incluyeTabla" 		default="true" 				type="boolean">		<!--- indica si el tag incluye la tabla o solo pinta las filas --->
<cfparam name="Attributes.incluyeHiddens"		default="true" 				type="boolean">		<!--- Se determina si los hiddens deben incluirse en la pantalla en caso que se desplieguen los datos en modo consulta --->
<cfparam name="Attributes.ocultar"				default="false" 			type="boolean">		<!--- Se determina si hay que ocultar las filas de entrada --->
<cfparam name="Attributes.index"				default=""					type="string">		<!--- tab index para los campos html --->
<cfparam name="Attributes.Ecodigo"				default="#Session.Ecodigo#"	type="integer">		<!--- Empresa --->
<cfparam name="Attributes.align"			 	default="left"				type="string">		<!--- alineacion de las etiquetas --->
<cfparam name="Attributes.div"					default="false"				type="boolean">		<!--- indica si deben de aparecer en diferentes columnas o en una misma --->
<cfoutput>
<cfif isdefined("Attributes.query") and isdefined("Attributes.query.RHTTid#Attributes.index#")>
	<cfset LvarRHTTid = Evaluate('Attributes.query.RHTTid#Attributes.index#')>
	<cfset LvarRHCid = Evaluate('Attributes.query.RHCid#Attributes.index#')>
	<cfset LvarRHMPPid = Evaluate('Attributes.query.RHMPPid#Attributes.index#')>
<cfelse>
	<cfset LvarRHTTid = ''>
	<cfset LvarRHCid = ''>
	<cfset LvarRHMPPid = ''>
</cfif>

</cfoutput>
<!--- VARIABLES DE TRADUCCION --->
<cfsilent>
<cfinvoke Key="LB_ListaTablasSalariales" Default="Lista de Tablas Salariales" returnvariable="LB_ListaTablasSalariales" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="LB_ListaPuestosPresupuestarios" Default="Lista de Puestos Presupuestarios" returnvariable="LB_ListaPuestosPresupuestarios" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="LB_ListaCategorias" Default="Lista de Categorías" returnvariable="LB_ListaCategorias" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke key="MSG_NoSeEncontraronRegistros" default="No se encontraron Registros"	 returnvariable="MSG_NoSeEncontraronRegistros" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Codigo" default="C&oacute;digo" xmlfile="/rh/generales.xml" returnvariable="LB_Codigo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Descripcion" default="Descripci&oacute;n" xmlfile="/rh/generales.xml" returnvariable="LB_Descripcion" component="sif.Componentes.Translate" method="Translate"/>
</cfsilent>
<!--- FIN VARIABLES DE TRADUCCION --->


<cfoutput>
<cfif Attributes.incluyeTabla>
	 <table border="0" cellpadding="0" cellspacing="0">
</cfif>
	<cfif Attributes.showTablaSalarial>
	  <tr id="trTipoTabla" <cfif Attributes.ocultar> style="display: none;"</cfif>>
		<td align="#Attributes.align#"><strong><cf_translate key="LB_TipoDeTabla">Tipo de Tabla</cf_translate></strong></td>
	  <cfif Attributes.div></tr><tr></cfif>
		<td height="25">
			<!--- <cfif not Attributes.tablaReadonly> --->
				<!---<cfset ArrayTabla = ''>
                <cfset filtro = ' '>
        
				<cfif not isdefined('LvarRHTTid')>
					<cfset ArrayTabla = ''>
					<cfset filtro = ' '>
				<cfelseif LEN(TRIM(LvarRHTTid))>
					<cfquery name="rsTabla" datasource="#session.DSN#">
						select RHTTid,RHTTcodigo, RHTTdescripcion
						from RHTTablaSalarial 
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Ecodigo#">
						 <!---  and RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarRHTTid#"> --->
					</cfquery>
					<cfset ArrayTabla='#rsTabla.RHTTid#,#rsTabla.RHTTcodigo#,#rsTabla.RHTTdescripcion#'>
					<cfset filtro = ' and RHTTid = #LvarRHTTid#'>
				</cfif>--->
				<cfset ArrayTabla = ''>
                <cfset filtro = ''>
				<cfset RHTTidAsig = 'RHTTid#Attributes.index#'>
				<cfset RHTTcodigoAsig = 'RHTTcodigo#Attributes.index#'>
				<cfset RHTTdescripcionAsig = 'RHTTdescripcion#Attributes.index#'>
				
        		<cfif LEN(TRIM(LvarRHTTid))>
        			<cf_translatedata name="get" tabla="RHTTablaSalarial" col="RHTTdescripcion" returnvariable="LvarRHTTdescripcion">
					<cfquery name="rsTablaSel" datasource="#session.DSN#">
						select RHTTid,RHTTcodigo, #LvarRHTTdescripcion# as  RHTTdescripcion
						from RHTTablaSalarial 
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Ecodigo#">
						and RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarRHTTid#">
					</cfquery>
					<cfset ArrayTabla='#rsTablaSel.RHTTid#,#rsTablaSel.RHTTcodigo#,#rsTablaSel.RHTTdescripcion#'>
				</cfif>
				<cf_conlis 
					title="#LB_ListaTablasSalariales#"
					campos = "RHTTid#Attributes.index#,RHTTcodigo#Attributes.index#, RHTTdescripcion#Attributes.index#" 
					desplegables = "N,S,S" 
					modificables = "N,S,N"
					size = "0,10,25"
					values="#ArrayTabla#" 
					tabla="RHTTablaSalarial"
					columnas="RHTTid as RHTTid#Attributes.index#, rtrim(RHTTcodigo) as RHTTcodigo#Attributes.index#, RHTTdescripcion as RHTTdescripcion#Attributes.index#"
					filtro="Ecodigo = #attributes.Ecodigo# #filtro#"
					desplegar="RHTTcodigo#Attributes.index#, RHTTdescripcion#Attributes.index#"
					filtrar_por="RHTTcodigo, RHTTdescripcion"
					etiquetas="#LB_Codigo#, #LB_Descripcion#"
					formatos="S,S"
					align="left,left"
					asignar="#RHTTidAsig#, #RHTTcodigoAsig#, #RHTTdescripcionAsig#"
					asignarformatos="I,S,S"
					height= "400"
					width="500"
					tabindex="1"
					index="#attributes.index#"
					readonly="#Attributes.tablaReadonly#"
					showEmptyListMsg="true"
					EmptyListMsg="#MSG_NoSeEncontraronRegistros#" 
					MAXCONLISES="500">
			</td>
		
	  </tr>
	</cfif>

	  <tr id="trPuestoCat" <cfif Attributes.ocultar> style="display: none;"</cfif> height="25">
		<td align="#Attributes.align#" nowrap><strong><cf_translate key="LB_Puesto" xmlFile="/rh/generales.xml">Puesto</cf_translate></strong></td>
		<cfif Attributes.div></tr><tr></cfif>
		<td>
			
				<cfset ArrayPuestoP = ''>
				<cfset filtroM = 'and RHTTid = $RHTTid#Attributes.index#,numeric$'>
				<cfset tablaM = 'RHMaestroPuestoP a inner join RHCategoriasPuesto b on b.RHMPPid = a.RHMPPid and b.Ecodigo = a.Ecodigo '>
				<cfif LEN(TRIM(LvarRHMPPid))>
					<cf_translatedata name="get" tabla="RHMaestroPuestoP" col="RHMPPdescripcion" returnvariable="LvarRHMPPdescripcion">
					<cfquery name="rsPuesto" datasource="#session.DSN#">
						select RHMPPid, RHMPPcodigo, <cf_dbfunction name="sReplace" args="#LvarRHMPPdescripcion#°','°''" delimiters="°"> as RHMPPdescripcion
						from RHMaestroPuestoP
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Ecodigo#">
						  and RHMPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarRHMPPid#">
					</cfquery>
					<cfset ArrayPuestoP='#rsPuesto.RHMPPid#,#rsPuesto.RHMPPcodigo#,#replace(rsPuesto.RHMPPdescripcion,",","","ALL")#'>
					
				</cfif>
				<cf_conlis 
					title="#LB_ListaPuestosPresupuestarios#"
					campos = "RHMPPid#Attributes.index#, RHMPPcodigo#Attributes.index#, RHMPPdescripcion#Attributes.index#" 
					desplegables = "N,S,S" 
					modificables = "N,S,N"
					size = "0,10,25"
					values="#ArrayPuestoP#" 
					tabla="#tablaM#"
					columnas="a.RHMPPid as RHMPPid#Attributes.index#, a.RHMPPcodigo as RHMPPcodigo#Attributes.index#, RHMPPdescripcion as RHMPPdescripcion#Attributes.index#"
					filtro="a.Ecodigo = #attributes.Ecodigo# #filtroM#"
					desplegar="RHMPPcodigo#Attributes.index#, RHMPPdescripcion#Attributes.index#"
					etiquetas="#LB_Codigo#, #LB_Descripcion#"
					filtrar_por="RHMPPcodigo, RHMPPdescripcion"
					formatos="S,S"
					align="left,left"
					asignar="RHMPPid#Attributes.index#, RHMPPcodigo#Attributes.index#, RHMPPdescripcion#Attributes.index#"
					asignarformatos="I,S,S"
					height= "400"
					width="500"
					readonly="#Attributes.tablaReadonly#"
					tabindex="1"
					index="#attributes.index#"
					showEmptyListMsg="true"
					EmptyListMsg="#MSG_NoSeEncontraronRegistros#" 
					MAXCONLISES="500">
		</td>
	  </tr>
	
	 <tr id="trCategoria" <cfif Attributes.ocultar> style="display: none;"</cfif>height="25">
		<td align="#Attributes.align#" nowrap valign="top"><strong><cf_translate key="LB_Categoria">Categor&iacute;a</cf_translate></strong></td>
		<cfif Attributes.div></tr><tr></cfif>
			<td>
				
				<cfset ArrayCat =''>
                <cfset filtroC = 'and RHMPPid = $RHMPPid#Attributes.index#,numeric$'>
				<cfset tablaC = 'RHCategoria a inner join RHCategoriasPuesto b on b.RHCid = a.RHCid and b.Ecodigo = a.Ecodigo  inner join RHTTablaSalarial c on c.RHTTid = b.RHTTid and c.Ecodigo = a.Ecodigo'>
				<cfif isdefined("LvarRHCid") and LEN(TRIM(LvarRHCid))>
					<cf_translatedata name="get" tabla="RHCategoria" col="RHCdescripcion" returnvariable="LvarRHCdescripcion">
					<cfquery name="rsCategoria" datasource="#session.DSN#">
						select RHCid, RHCcodigo, <cf_dbfunction name="sReplace" args="#LvarRHCdescripcion#°','°''" delimiters="°"> as RHCdescripcion
						from RHCategoria
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						  and RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarRHCid#">
					</cfquery>
					<cfset ArrayCat='#LvarRHCid#,#rsCategoria.RHCcodigo#,#rsCategoria.RHCdescripcion#'>
				</cfif>
				
				<cf_dbfunction name="OP_concat"	returnvariable="cat">
				<cf_conlis 
					title="#LB_ListaCategorias#"
					campos = "RHCid#Attributes.index#,RHCcodigo#Attributes.index#,RHCdescripcion#Attributes.index#" 
					desplegables = "N,S,S" 
					modificables = "N,S,N"
					size = "0,10,25"
					values="#ArrayCat#" 
					tabla="#tablaC#"
					columnas="a.RHCid as RHCid#Attributes.index#, '(' #cat# c.RHTTcodigo #cat# ') ' #cat# RHCcodigo as RHCcodigo#Attributes.index#,RHCdescripcion as RHCdescripcion#Attributes.index#"
					filtro="a.Ecodigo = #attributes.Ecodigo# #filtroC#"
					desplegar="RHCcodigo#Attributes.index#,RHCdescripcion#Attributes.index#"
					etiquetas="#LB_Codigo#, #LB_Descripcion#"
					formatos="S,S"
					filtrar_por="RHCcodigo,RHCdescripcion"
					align="left,left"
					asignar="RHCid#Attributes.index#,RHCcodigo#Attributes.index#,RHCdescripcion#Attributes.index#"
					asignarformatos="I,S,S"
					height= "400"
					width="500"
					tabindex="1"
					index="#attributes.index#"
					showEmptyListMsg="true"
					readonly="#Attributes.categoriaReadonly#"
					EmptyListMsg="#MSG_NoSeEncontraronRegistros#" 
					MAXCONLISES="500">
				
		</td>
	  </tr>

<cfif Attributes.incluyeTabla>
	</table>
</cfif>
</cfoutput>
