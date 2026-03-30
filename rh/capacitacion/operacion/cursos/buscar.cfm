﻿<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_AgregarCurso"
	Default="Agregar Curso"
	returnvariable="LB_AgregarCurso"/>
<!--- FIN VARIABLES DE TRADUCCION --->

<cf_web_portlet_start titulo="#LB_AgregarCurso#">
	<cfquery datasource="#session.dsn#" name="listaBuscar">
		select i.RHIAid, i.RHIAnombre, m.Mcodigo, m.Msiglas, m.Mnombre,
			{fn concat('<em>&nbsp;',{fn concat(coalesce (ac.RHACdescripcion,'Sin Clasificar'),'</em>')})} as RHACdescripcion
		from RHOfertaAcademica oa
			join RHInstitucionesA i
				on oa.RHIAid  = i.RHIAid
			join RHMateria m
				on oa.Mcodigo = m.Mcodigo
			left join RHAreasCapacitacion ac
				on m.RHACid = ac.RHACid
			<cfif Len(url.filtro_RHGMid) and url.filtro_RHGMid neq 'null'>
			  join RHMateriasGrupo mg 
				on m.Mcodigo = mg.Mcodigo
				  and mg.RHGMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.filtro_RHGMid#"> 
			</cfif>
			where i.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			  and m.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			  and oa.RHOAactivar = 1
			<cfif url.filtro_RHGMid eq 'null'>
			  and not exists (select 1 from RHMateriasGrupo mg 
					where m.Mcodigo = mg.Mcodigo
					  and mg.RHGMid is null )
			</cfif>
			<cfif url.filtro_RHACid eq 'null'>
			  and m.RHACid is null
			<cfelseif Len(url.filtro_RHACid)>
			  and m.RHACid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.filtro_RHACid#">
			</cfif>
			<cfif Len(url.filtro_RHIAid)>
			  and i.RHIAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.filtro_RHIAid#">
			</cfif>
			<cfif Len(url.filtro_Mnombre)>
			  and (upper( m.Mnombre ) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(url.filtro_Mnombre)#%">
			    or upper( m.Msiglas ) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(url.filtro_Mnombre)#%"> )
			</cfif> 
		order by i.RHIAnombre, m.Msiglas
	</cfquery>
	
	
	

      <table width="100%"  border="0" >
        <tr align="center">
          <td valign="top">
		  <cfinclude template="agregar_info.cfm">
          </td>
        </tr>
        <tr>
          <td valign="top"><form action="ofertaint-apply.cfm" method="get" name="listaBuscar" id="listaBuscar">
		  
		  

			<cfinvoke 
				 component="rh.Componentes.pListas"
				 method="pListaQuery" 
				 mostrar_filtro="no" >
					<cfinvokeargument name="query" value="#listaBuscar#"/>
					<cfinvokeargument name="desplegar" value="Msiglas,Mnombre"/>
					<cfinvokeargument name="etiquetas" value="Curso,&nbsp;"/>
					<cfinvokeargument name="formatos" value="S, S"/>
					<cfinvokeargument name="align" value="left, left"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="irA" value="agregar.cfm"/>
					<cfinvokeargument name="checkboxes" value="N">
					<cfinvokeargument name="keys" value="RHIAid,Mcodigo">
					<cfinvokeargument name="formName" value="listaBuscar">
					<cfinvokeargument name="incluyeform" value="no">
					<cfinvokeargument name="cortes" value="RHIAnombre,RHACdescripcion">
					<cfinvokeargument name="showEmptyListMsg" value="true">
					<cfinvokeargument name="EmptyListMsg" value="*** NO SE HAN REGISTRADO CURSOS ***">
					<cfinvokeargument name="navegacion" value="#navegacion#">
		  </cfinvoke> 
		  
		  <cfinclude template="url_hidden.cfm"> 
          </form>      </td>
        </tr>
      </table>

<script type="text/javascript">
<!--
	function checkall_click(f,checked,prefix){
		for (var i=0; i < f.elements.length; i++){
			if (f.elements[i].name.substring(0,prefix.length) == prefix){
				f.elements[i].checked = checked;
			}
		}
	}
//-->
</script>
	<cf_web_portlet_end>
