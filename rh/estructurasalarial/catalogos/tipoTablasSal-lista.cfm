<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="LB_RecursosHumanos" Default="Recursos Humanos" returnvariable="LB_RecursosHumanos" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke key="LB_EscalasSalariales" default="Escalas Salariales" returnvariable="LB_EscalasSalariales" component="sif.Componentes.Translate" method="Translate"/>	 
<cfinvoke Key="LB_Codigo" Default="Código" returnvariable="LB_Codigo" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="LB_Descripcion" Default="Descripción" returnvariable="LB_Descripcion" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="BTN_Nuevo" Default="Nuevo" returnvariable="BTN_Nuevo" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
 
<!--- FIN VARIABLES DE TRADUCCION --->
<cfset filtro = ''>
		<cfset navegacion = ''>
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td valign="top"> 
				<cf_translatedata name="get" tabla="RHTTablaSalarial" col="RHTTdescripcion" returnvariable="LvarRHTTdescripcion">
				<cf_dbfunction name="length" args="#LvarRHTTdescripcion#" returnvariable="LvarLenLvarRHTTdescripcion"> 
				<cf_dbfunction name="spart" args="#LvarRHTTdescripcion#!1!30" delimiters="!" returnvariable="LvarStringLvarRHTTdescripcion"> 
				<cf_dbfunction name="op_concat"  returnvariable="concat"> 

				<cfinvoke 
				 component="rh.Componentes.pListas"
				 method="pListaRH"
				 returnvariable="pListaRHRet">
					<cfinvokeargument name="tabla" value="RHTTablaSalarial"/>
					<cfinvokeargument name="columnas" value="RHTTid,RHTTcodigo,case when #LvarLenLvarRHTTdescripcion# > 30 then #LvarStringLvarRHTTdescripcion# #concat# '...' else #LvarRHTTdescripcion# end as RHTTdescripcion "/>
					<cfinvokeargument name="desplegar" value="RHTTcodigo,RHTTdescripcion"/>
					<cfinvokeargument name="etiquetas" value="#LB_Codigo#,#LB_Descripcion#"/>
					<cfinvokeargument name="formatos" value="S,S"/>
					<cfinvokeargument name="filtro" value="Ecodigo = #Session.Ecodigo# #filtro# order by RHTTcodigo, #LvarRHTTdescripcion#"/>
					<cfinvokeargument name="align" value="left,left"/>
					<cfinvokeargument name="ajustar" value="S"/>
					<cfinvokeargument name="irA" value="tipoTablasSal.cfm"/>
					<cfinvokeargument name="maxRows" value="10"/>
					<cfinvokeargument name="keys" value="RHTTid"/>
					<cfinvokeargument name="navegacion" value="#navegacion#"/>
					<cfinvokeargument name="botones" value="#BTN_Nuevo#"/>
					<cfinvokeargument name="filtrar_automatico" value="true"/>
					<cfinvokeargument name="mostrar_filtro" value="true"/>
				</cfinvoke>
			</td>	
		</tr>
	</table>	
