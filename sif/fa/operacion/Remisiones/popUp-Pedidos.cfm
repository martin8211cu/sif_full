<!---►►JS◄◄--->
<script language="JavaScript1.2" src="../../js/utilesMonto.js"></script>

<!---►►Filtros◄◄--->
<CF_NAVEGACION NAME="EOidorden">
<cfif isdefined("url.ESnumero_f")      and len(url.ESnumero_f)      and not isdefined("form.ESnumero_f")><cfset form.ESnumero_f = url.ESnumero_f></cfif>
<cfif isdefined("url.CMTSdescripcion") and len(url.CMTSdescripcion) and not isdefined("form.CMTSdescripcion")><cfset form.CMTSdescripcion = url.CMTSdescripcion></cfif>
<cfif isdefined("url.Ccodigo") 		   and len(url.Ccodigo)         and not isdefined("form.Ccodigo")><cfset form.Ccodigo = url.Ccodigo></cfif>
<cfif isdefined("url.CFcodigo")        and len(url.CFcodigo)        and not isdefined("form.CFcodigo")><cfset form.CFcodigo = url.CFcodigo></cfif>
<cfif isdefined("url.Ecodigo")        and len(url.Ecodigo)        and not isdefined("form.Ecodigo")><cfset form.Ecodigo= url.Ecodigo></cfif>

<cfparam name="form.Ecodigo" default="#session.Ecodigo#">
<cfparam name="form.ESnumero_f" default="">
<cfset navegacion = "">
<cfif isdefined("form.EOidorden") and len(trim(form.EOidorden)) >
	<cfset navegacion = navegacion & "&EOidorden=#form.EOidorden#">
</cfif>

<!---►►Categorias◄◄--->
<cfquery name="rsCategorias" datasource="#session.DSN#" >
	select ACcodigo, ACdescripcion
	from ACategoria
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ecodigo#">
</cfquery>

<!---►►Clasificacion◄◄--->
<cfquery name="rsClasificacion" datasource="#Session.DSN#">
	select ACid, ACdescripcion, ACcodigo
	from AClasificacion
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ecodigo#">
	order by ACcodigo, ACdescripcion
</cfquery>

<!---►►Socio Negocios◄◄--->
<cfquery name="rsSN" datasource="#Session.DSN#">
  select ee.SNcodigo
    from ERemisionesFA ee
   where ee.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ecodigo#">
     and ee.EOidorden= #form.EOidorden#
</cfquery>
<!---►►Solicitudes de Compra◄◄--->



<cf_dbfunction name="op_concat" returnvariable="_Cat">
<cfquery name="rsListaItems" datasource="#Session.DSN#">
          select 
		  #form.EOidorden# as idRemisionOrden,
		  er.EOidorden,
          er.EOnumero,
          er.SNcodigo,
          er.EOfecha,
          er.EOtotal
          from EPedido er
                where er.EOestado in (10)
                  and er.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ecodigo#">
		order by er.EOnumero
</cfquery>
<cfoutput>
	<form style="margin: 0" action="popUp-solicitudCompra.cfm?Ecodigo=<cfoutput>#form.Ecodigo#</cfoutput>" name="fsolicitud" id="fsolicitud" method="post">
    	<input type="hidden" value="#form.EOidorden#" name="EOidorden">
        <table width="100%" border="0" cellspacing="0" cellpadding="2" class="areaFiltro">
        	<tr>
	                <td class="fileLabel" nowrap width="8%" align="right"><label for="ESnumero">Pedido:</label></td>
	                <td nowrap width="31%">
	               	   <cf_inputNumber comas="false" name="ESnumero_f" Enteros="6" value="#form.ESnumero_f#" style="text-transform: uppercase;" tabindex="1">
	            	</td>

				    <td class="fileLabel" nowrap width="9%" align="right">Descripci&oacute;n:</td>
	                <td nowrap width="25%"><input type="text" name="CMTSdescripcion" size="20" maxlength="100" value="<cfif isdefined('form.CMTSdescripcion')>#form.CMTSdescripcion#</cfif>" style="text-transform: uppercase;" tabindex="1">
	                </td>

	                <td colspan="2">
	                </td>
            </tr>

            <tr>
					<td class="fileLabel" nowrap width="9%" align="right"><!--- NAP: ---></td>
	                <td width="27%" rowspan="1" align="left" valign="center">
	                   <!--- <input type="text"
	                   onFocus="javascript:this.value=qf(this); this.select();"
	                   onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}"
	                   name="NAP" size="10" maxlength="10" value="<cfif isdefined('form.NAP')>#form.NAP#</cfif>" style="text-transform: uppercase;" tabindex="1"> --->
	                </td>

					<td class="fileLabel" align="right" nowrap>Centro Funcional:</td>
	                <td nowrap width="25%">
	                  <cf_conlis
	                    Campos="CFid,CFcodigo,CFdescripcion"
	                    tabindex="6"
	                    Desplegables="N,S,S"
	                    Modificables="N,S,N"
	                    Size="0,15,35"
	                    Title="Lista de Centros Funcionales"
	                    Tabla="CFuncional cf"
	                    Columnas="CFid,CFcodigo,CFdescripcion"
	                    Filtro="Ecodigo = #form.Ecodigo# order by CFcodigo,CFdescripcion"
	                    Desplegar="CFcodigo,CFdescripcion"
	                    Etiquetas="C&oacute;digo,Descripci&oacute;n"
	                    filtrar_por="CFcodigo,CFdescripcion"
	                    Formatos="S,S"
	                    form="fsolicitud"
	                    Align="left,left"
	                    Asignar="CFid,CFcodigo,CFdescripcion"
	                    Asignarformatos="I,S,S"
	                    />
	                </td>

            </tr>



            <tr>
					<td class="fileLabel" nowrap width="9%" align="right">Tipo Solicitud:</td>
                  	<td width="27%" rowspan="1" align="left" valign="center">
					  	<select name="TipoItem" tabindex="1" value ="this.value"  onchange="this.form.submit()">
							<option value=""<cfif not isdefined("form.TipoItem") OR form.TipoItem EQ "">selected</cfif>>Todos</option></option>
							<option value="A"<cfif isdefined("Form.TipoItem") and (Form.TipoItem eq "A")>selected</cfif>>Art&iacute;culo</option>
							<option value="S"<cfif isdefined("Form.TipoItem") and (Form.TipoItem eq "S")>selected</cfif>>Servicio</option>
                            <option value="F"<cfif isdefined("Form.TipoItem") and (Form.TipoItem eq "F")>selected</cfif>>Activo</option>
						</select>
                    </td>
					<td colspan="2" width="27%" rowspan="1" align="center" valign="center"><input type="submit" class="btnFiltrar" name="btnFiltro" value="Filtrar"></td>
            </tr>
            <tr>

			<cfif isdefined("form.TipoItem") and form.TipoItem EQ 'A'>
				<td class="fileLabel" align="right" nowrap>Art&iacute;culo:&nbsp;</td>
                <td>
                	<input type="hidden" name="Almacen" value="" />
                	<cf_sifarticulos form="fsolicitud" id="Aid" almacen="Almacen" tabindex="2">
                </td>
			</cfif>

			<cfif isdefined("form.TipoItem") and form.TipoItem EQ 'F'>
                   <td class="fileLabel" align="right" nowrap>Categor&iacute;a:</td>
                    <td nowrap width="25%">
                         <select name="ACcodigo" onChange="javascript:cambiar_categoria();" tabindex="2" >
                            <cfloop query="rsCategorias">
                                <option value="#rsCategorias.ACcodigo#">#rsCategorias.ACdescripcion#</option>
                            </cfloop>
                          </select>
                    </td>

                    <td class="fileLabel" align="right" nowrap>Clasificaci&oacute;n:</td>
                    <td nowrap width="25%">
                        <select name="ACid" tabindex="2">
                        </select>
                    </td>
                    <td colspan="2">
                    </td>
			</cfif>

			<cfif isdefined("form.TipoItem") and form.TipoItem EQ 'S'>
			    <td class="fileLabel" nowrap width="9%" align="right">Servicio:</td>
                <td nowrap width="25%">
                    <cf_conlis
                        Campos="Cid,Ccodigo,Cdescripcion"
                        tabindex="6"
                        Desplegables="N,S,S"
                        Modificables="N,S,N"
                        Size="0,15,35"
                        Title="Lista Conceptos de Servicios"
                        Tabla="Conceptos c"
                        Columnas="Cid,Ccodigo,Cdescripcion"
                        Filtro="Ecodigo = #form.Ecodigo# order by Ccodigo,Cdescripcion"
                        Desplegar="Ccodigo,Cdescripcion"
                        Etiquetas="C&oacute;digo,Descripci&oacute;n"
                        filtrar_por="Ccodigo,Cdescripcion"
                        Formatos="S,S"
                        form="fsolicitud"
                        Align="left,left"
                        Asignar="Cid,Ccodigo,Cdescripcion"
                        Asignarformatos="I,S,S"/>
               	</td>
			</cfif>

        	</tr>
    	</table>
	</form>
</cfoutput>
<!---Lista de Items--->
<table align="center" width="99%"  border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td class="subTitulo"><font size="2">Lista de Detalles</font></td>
	</tr>
</table>

<table align="center" width="99%"  border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td>
            <cfinvoke component="sif.Componentes.pListas" method="pListaQuery">
                    <cfinvokeargument name="query" 				value="#rsListaItems#">
                    <cfinvokeargument name="desplegar" 			value="EOfecha, EOnumero,SNcodigo , EOtotal">
                    <cfinvokeargument name="etiquetas" 			value="Fecha, Numero,SNcodigo,EOtotal">
                    <cfinvokeargument name="formatos" 			value="D,V,V,M">
                    <cfinvokeargument name="align" 				value="left,left,left,left">
                    <cfinvokeargument name="ajustar" 			value="S">
					<cfinvokeargument name="checkboxes" value="S"/>
                    <cfinvokeargument name="checkall" value="S"/>
                    <cfinvokeargument name="showEmptyListMsg" 	value="true">
                    <cfinvokeargument name="irA" 				value="popUp-Pedidos-SQL.cfm">
                    <cfinvokeargument name="formName" 			value="form3">
                    <cfinvokeargument name="maxrows" 			value="50"/>
                    <cfinvokeargument name="keys" 				value="idRemisionOrden, EOidorden">
                    <cfinvokeargument name="funcion" 			value="ProcesarLinea">
                    <cfinvokeargument name="fparams" 			value="idRemisionOrden, EOidorden">
                    <cfinvokeargument name="navegacion" 		value="#navegacion#"/>
                    <cfinvokeargument name="usaAjax" 			value="true"/>
                    <cfinvokeargument name="conexion" 			value="#session.dsn#"/>
                    <!--- <cfinvokeargument name="Cortes" 			value="corte"/>
                    <cfinvokeargument name="chkcortes" 			value="S"/> --->
                 <cfif isdefined ("rsListaItems") and rsListaItems.recordcount GT 0>
                    <cfinvokeargument name="botones" 			value="Agregar"/>
                </cfif>
            </cfinvoke>
        </td>
    </tr>
</table>
<hr width="99%" align="center">
<script language='javascript' type='text/JavaScript' >
	function ProcesarLinea(Linea){
		return false;
	}
	function cambiar_categoria() {
		var categoria = document.fsolicitud.ACcodigo.value;
		var combo = document.fsolicitud.ACid;
		var cont = 0;
		combo.length=0;
		<cfoutput query="rsClasificacion">
			if (#Trim(rsClasificacion.ACcodigo)#==trim(categoria))
			{
				combo.length=cont+1;
				combo.options[cont].value='#rsClasificacion.ACid#';
				combo.options[cont].text='#rsClasificacion.ACdescripcion#';
				cont++;
			};
		</cfoutput>
	}
</script>

