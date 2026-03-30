<cfset navegacion2 = "">
<cfset campos_extra = ''>
<cfif isdefined("Form.Pagina") and Len(Trim(Form.Pagina))>
	<cfset navegacion2 = navegacion2 & "&Pagina=" & Form.Pagina>
	<cfset campos_extra = campos_extra & ",'#form.Pagina#' as Pagina" >
</cfif>
<cfif isdefined("Form.filtro_LCcod") and Len(Trim(Form.filtro_LCcod))>
	<cfset navegacion2 = navegacion2 & "&filtro_LCcod=" & Form.filtro_LCcod>
	<cfset campos_extra = campos_extra & ",'#form.filtro_LCcod#' as filtro_LCcod" >
</cfif>
<cfif isdefined("Form.filtro_LCnombre") and Len(Trim(Form.filtro_LCnombre))>
	<cfset navegacion2 = navegacion2 & "&filtro_LCnombre=" & Form.filtro_LCnombre>
	<cfset campos_extra = campos_extra & ",'#form.filtro_LCnombre#' as filtro_LCnombre" >
</cfif>
<cfif isdefined("Form.filtro_DPnombre") and Len(Trim(Form.filtro_DPnombre))>
	<cfset navegacion2 = navegacion2 & "&filtro_DPnombre=" & Form.filtro_DPnombre>
	<cfset campos_extra = campos_extra & ",'#form.filtro_DPnombre#' as filtro_DPnombre" >
</cfif>
<cfif isdefined("Form.modoLoc") and Len(Trim(Form.modoLoc))>
	<cfset navegacion2 = navegacion2 & "&modoLoc=" & Form.modoLoc>
</cfif>
<cfif isdefined("Form.btnNuevo") and Len(Trim(Form.btnNuevo))>
	<cfset navegacion2 = navegacion2 & "&btnNuevo=" & Form.btnNuevo>
	<cfset campos_extra = campos_extra & ",'#form.btnNuevo#' as btnNuevo" >
</cfif>
<cfif isdefined("Form.LCid") and Len(Trim(Form.LCid))>
	<cfset navegacion2 = navegacion2 & "&LCid=" & Form.LCid>
</cfif>

<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL SQL--->
<cfparam name="form.MaxRows2" default="15">	
<cfparam name="form.Pagina2" default="1">

<cfif isdefined("form.pagenum_lista")>
	<cfset campos_extra = ",'#form.pagenum_lista#' as pagenum_lista" >
</cfif>	

<cfinvoke 
	component="sif.Componentes.pListas"
	method="pLista"
	returnvariable="pListaRet">
	<cfinvokeargument name="tabla" value="Localidad"/>
	<cfinvokeargument name="columnas" value="LCid
											, LCcod as LCcodb
											, LCnombre as LCnombreb
											, LCidPadre
											, 'CAMBIO' as modoLoc
											#preservesinglequotes(campos_extra)#"/>													
	<cfinvokeargument name="desplegar" value="LCcodb,
											 LCnombreb"/> 
	<cfinvokeargument name="etiquetas" value="C&oacute;digo, Descripci&oacute;n"/>
	<cfinvokeargument name="formatos" value="V,V"/> 									
	<cfinvokeargument name="filtro" value="	1=1
											#filtroDin#
											order by 2, 3"/> 
	<cfinvokeargument name="align" value="left,left"/>
	<cfinvokeargument name="ajustar" value="N"/> 
	<cfinvokeargument name="checkboxes" value="N"/> 
	<cfinvokeargument name="irA" value="Localidad.cfm"/> 									
	<cfinvokeargument name="showEmptyListMsg" value="true"/>
	<cfinvokeargument name="keys" value="LCid"/> 
	<cfinvokeargument name="debug" value="N"/>
	<cfinvokeargument name="maxRows" value="#form.MaxRows2#"/>
	<cfinvokeargument name="PageIndex" value="2"/>	
	<cfinvokeargument name="mostrar_filtro" value="true"/>
	<cfinvokeargument name="filtrar_por" value="LCcod, LCnombre"/>									
	<cfinvokeargument name="navegacion" value="#navegacion2#"/>
	<cfinvokeargument name="filtrar_automatico" value="true"/>																													
</cfinvoke>

<script language="javascript" type="text/javascript">
	function funcFiltrar2(){
		<cfoutput>
			<cfif isdefined("Form.LCid") and Len(Trim(Form.LCid))>
				document.lista.LCID.value = "#form.LCid#";
			</cfif>					
			<cfif isdefined("Form.Pagina") and Len(Trim(Form.Pagina))>
				document.lista.PAGINA.value = "#form.pagina#";
			</cfif>			
			<cfif isdefined("Form.filtro_LCcod") and Len(Trim(Form.filtro_LCcod))>
				document.lista.FILTRO_LCCOD.value = "#form.filtro_LCcod#";
			</cfif>
			<cfif isdefined("Form.filtro_LCnombre") and Len(Trim(Form.filtro_LCnombre))>
				document.lista.FILTRO_LCNOMBRE.value = "#form.filtro_LCnombre#";
			</cfif>
			<cfif isdefined("Form.filtro_DPnombre") and Len(Trim(Form.filtro_DPnombre))>
				document.lista.FILTRO_DPNOMBRE.value = "#form.filtro_DPnombre#";			
			</cfif>		
			<cfif not isdefined("Form.modoLoc")>
				document.lista.MODOLOC.value = "CAMBIO";
			<cfelse>
				document.lista.MODOLOC.value = "#Form.modoLoc#";
			</cfif>				
		</cfoutput>
		
		return true;
	}
</script>