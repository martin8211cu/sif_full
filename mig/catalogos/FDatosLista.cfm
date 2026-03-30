<cfif isdefined ('form.Importar')>
	<cflocation url="FDatosImportador.cfm">
</cfif>
<script src="/cfmx/sif/js/utilesMonto.js"></script>
<cfquery name="rsTipos" datasource="#session.DSN#">
	select  '' as value,'Todos' as description from dual
	union all
	select  'P' as value,'Producto' as description from dual
	union all
	select  'D' as value, 'Departamento' as description from dual
	union all
	select 'C' as value,'Cuenta' as description from dual
</cfquery>

<cfparam name="filtro" default="">
<cfparam name="navegacion" default="">

<cfquery datasource="#session.DSN#" name="rsLote"><!---poner condicion para que traiga solo un valor--->
	select distinct Lote from F_Datos where Ecodigo = #session.Ecodigo# 	
	<cfif isdefined("form.fMIGMid") and len(trim(form.fMIGMid))>
		and MIGMid = #form.fMIGMid#
	</cfif>
	 order by Lote
</cfquery>


<cfset LvarIniciales=false>
<cfset LvarIDR=0>


<!---filtros--->
<cfif isdefined("url.fLote") and len(trim(url.fLote))>
	<cfset form.fLote = url.fLote>	
</cfif>

<cfif isdefined("form.fLote") and len(trim(form.fLote))>
	<cfset filtro = filtro  & "and a.Lote = " & trim(form.fLote)>
	<cfset form.Lote = form.fLote>			
	<cfset navegacion= navegacion & '&fLote='&form.fLote>
</cfif>


<cfif isdefined("url.fMIGMid") and len(trim(url.fMIGMid))>
	<cfset form.FMIGMid = url.fMIGMid>	
</cfif>

<cfif isdefined("form.fMIGMid") and len(trim(form.fMIGMid)) and form.fMIGMid NEQ -1 and isdefined("form.Filtrar")>
	<cfset filtro = filtro  & "and b.MIGMid = " & trim(form.fMIGMid)>
	<cfset form.MIGMid = form.fMIGMid>			
	<cfset LvarIniciales=true>
	<cfset LvarIDR=form.MIGMid>
	<cfset navegacion= navegacion & '&FMIGMid='&form.MIGMid>
<cfelseif not isdefined("form.fMIGMid")>
	<cfset filtro = filtro  & " and b.MIGMid = -1">
</cfif>

<cfparam name="form.Lote" default="">

<cfoutput>
	<table width="100%" border="0" align="center">
		<form name="formLote" method="post" action="FDatos.cfm" style="margin: '0' ">
		<tr> 
			<td colspan="2">
				<strong>Elija un Lote:</strong> &nbsp;
				<select name="fLote" id="fLote" >
					<option value="">--Todos--</option>
					<cfloop query="rsLote">
						<option value="#rsLote.Lote#" <cfif isdefined("form.fLote") and form.fLote EQ rsLote.Lote>selected="selected"</cfif>>#rsLote.Lote#</option>
					</cfloop>
				</select>
			</td>
            <td align="right">M&eacute;trica:</td>
            <td align="left" nowrap="nowrap" >
                <cf_conlis title="Lista de M&eacute;tricas"
                        tabla="MIGMetricas b"
                        columnas="b.MIGMid as fMIGMid,b.MIGMcodigo,b.MIGMdescripcion"
                        campos = "fMIGMid,MIGMcodigo,MIGMdescripcion"
                        desplegables = "N,S,S" 
                        modificables = "N,S,N" 
                        filtro="Ecodigo=#session.Ecodigo#"
                        desplegar="MIGMcodigo,MIGMdescripcion"
                        etiquetas="Codigo,Nombre"
                        formatos="S,S"
                        align="left,left"
                        filtrar_por="MIGMcodigo,MIGMdescripcion"
                        tabindex="1"
                        size="0,20,60"
                        fparams="fMIGMid"
                        form="formLote"
                        traerInicial="#LvarIniciales#"
                        traerFiltro="MIGMid=#LvarIDR#"			
                        /> 
            </td>
            <td align="right">Ver:</td>
            <td>
                <input name="FCantidaReg" id="FCantidaReg" type="text" 
                    value="<cfif isdefined("form.FCantidaReg") and len(trim(form.FCantidaReg))>#form.FCantidaReg#</cfif>" 
                    maxlength="7" size="8" 
                    onkeypress	= "return _CFinputText_onKeyPress(this,event,7,0,false,true);"
                    onkeyup		= "_CFinputText_onKeyUp(this,event,7,0,false,true);"/>
            </td>
            <td>
                <input name="Filtrar" type="submit" value="Filtrar" onclick="return funcFiltrar();" />
            </td>
        </tr>
            
        </form> 
        <form name="formRedirec" method="post" action="FDatos.cfm" style="margin: '0' ">
        <tr> 
            <td colspan="5">
                <cfif isdefined("form.FCantidaReg") and len(trim(form.FCantidaReg)) eq 0>
                    <cfset form.FCantidaReg = -1>
                <cfelseif not isdefined("form.FCantidaReg")>
                    <cfset form.FCantidaReg = -1>
                </cfif>
                <cfset LvarMaxRows = 20>
                <cfif isdefined("form.FCantidaReg") and len(trim(form.FCantidaReg)) and form.FCantidaReg gt 0>
                     <cfset LvarMaxRows = form.FCantidaReg>
                </cfif>
                
                <cfquery name="rsLista" datasource="#session.DSN#">
                    select a.id_datos,a.Lote,a.MIGMid,b.MIGMcodigo,a.Pfecha,c.MIGCuecodigo,p.MIGProcodigo,e.Deptocodigo,
                                case b.MIGMtipodetalle 
                                    when 'D' then 'Deparmento' 
                                    when 'C' then 'Cuenta' 
                                    when 'P' then 'Producto'
                                end as MIGMtipodetalle
                                <cfif isdefined("form.fMIGMid") and len(trim(form.fMIGMid))>
                                    ,#form.FMIGMid# as FMIGMid
                                </cfif>
                                <cfif isdefined("form.fLote") and len(trim(form.fLote))>
                                    ,#form.fLote# as fLote
                                </cfif>
                                , '1' as valido
                    from F_Datos a 
                            inner join MIGMetricas b 
                                on b.MIGMid = a.MIGMid
                                and a.Ecodigo=b.Ecodigo
                            left outer join MIGProductos p
                                on p.MIGProid=a.MIGProid
                                and a.Ecodigo=p.Ecodigo
                            left outer join MIGCuentas c
                                on  c.MIGCueid=a.MIGCueid
                                and a.Ecodigo=c.Ecodigo
                            left outer join Departamentos e
                                on  e.Dcodigo=a.Dcodigo
                                and a.Ecodigo=e.Ecodigo
                    where a.Ecodigo=#session.Ecodigo#
                    and b.Dactiva=1
                    #filtro#
                    group by a.id_datos,a.Lote,a.MIGMid,b.MIGMcodigo,a.Pfecha,c.MIGCuecodigo,p.MIGProcodigo,e.Deptocodigo,b.MIGMtipodetalle
                    order by a.Lote desc,b.MIGMcodigo,a.Pfecha,e.Deptocodigo,c.MIGCuecodigo,p.MIGProcodigo
                </cfquery>

                <cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
                    query="#rsLista#"
                    desplegar="Lote,MIGMcodigo,Deptocodigo,MIGProcodigo,MIGCuecodigo,Pfecha,MIGMtipodetalle"
                    etiquetas="Lote,Metrica,Cód Depto,Cód Producto,Cód Cuenta,Desde,Tipo Filtro"
                    formatos="S,S,S,S,S,D,S"
                    keys="id_datos"
                    mostrar_filtro="no"
                    align="left,left,left,left,left,left,left"
                    ira="FDatos.cfm"
                    MaxRows="#LvarMaxRows#"
                    cortes="MIGMcodigo"
                    showEmptyListMsg="true"
                    incluyeForm="False"
                    formName="formRedirec"
                    rsMIGMtipodetalle="#rsTipos#"
                    inactivecol="valido"
                    navegacion="#navegacion#"
                    checkboxes="S"
                    checkall = "S" />
            </td>
        </tr>
        <tr>
            <td align="center" colspan="5">
                
                    
                    <cfif isdefined("url.PageNum_lista") and len(trim(url.PageNum_lista))>
                        <input name="pagenumL" type="hidden" value="#url.PageNum_lista#">
                    </cfif>
                    
                    <input name="LoteL" type="hidden" value="#form.Lote#">
                    <cfif isdefined("form.fMIGMid") and len(trim(form.fMIGMid))>
                        <input name="FMIGMidL" type="hidden" value="#form.FMIGMid#">
                    </cfif> 
                    <cfif isdefined("form.fLote") and len(trim(form.fLote))>
                        <input name="fLoteL" type="hidden" value="#form.fLote#">
                    </cfif>
                    <input name="Nuevo" type="submit" value="Nuevo" tabindex="2">
                    <input name="Importar" type="submit" value="Importar" tabindex="2">
                    <input name="Eliminar" type="submit" value="Eliminar" tabindex="2" onclick="return funcEliminar();">
            </td>
        </tr> 
        </form>
	</table>
</cfoutput>
<script type="text/javascript" language="javascript">
	function funcFiltrar() {
		if(document.formLote.FCantidaReg.value > 500){
					alert('No se recomienda ver en pantalla mas de 500 registros a la vez');
					return false;
			} else {
				return true;
			}
		}
		
	function algunoMarcado()
		{
			var f = document.formRedirec;
			if (f.chk) {
				if (f.chk.checked) {
					return true;
				} else {
					for (var i=0; i<f.chk.length; i++) {
						if (f.chk[i].checked) { 
							return true;
						}
					}
				}
			}
			return false;
		}
		
	function funcEliminar() 
		{
			if (algunoMarcado()) {
				if(confirm('Esta seguro que desea eliminar los registros seleccionados ?')) {
					document.formRedirec.action='FDatosSQL.cfm';
					return true;
				}
			} else {
				alert("Debe seleccionar al menos un registro de la lista para poder eliminarlo!");
			}
			return false;
		}
</script>
    