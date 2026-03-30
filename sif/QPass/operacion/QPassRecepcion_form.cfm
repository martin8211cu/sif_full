<cfif isdefined("url.QPTid") and not isdefined("form.QPTid") and len(trim(url.QPTid))>
	<cfset form.QPTid = url.QPTid>
</cfif>

<cfinclude template="../../Utiles/sifConcat.cfm">

<cfset modo = 'Alta'><!--- Solo se puede entrar en modo cambio --->
<cfif isdefined("form.QPTid") and len(trim(form.QPTid)) and not isdefined("form.Nuevo")>
	<cfset modo = 'Cambio'>
</cfif>

<cfif modo neq 'Alta'>
    <cfquery name="QPassTraslado" datasource="#session.DSN#">
    	select
        	a.QPTid,
            rtrim(b.Oficodigo) #_Cat# ' ' #_Cat# b.Odescripcion  as OficodigoOri,
            rtrim(c.Oficodigo) #_Cat# ' ' #_Cat# c.Odescripcion as OficodigoDest,
            a.OcodigoOri,
            a.OcodigoDest,
            a.QPTtrasDocumento as codigo,
            a.QPTtrasDescripcion as descripcion,
            a.QPTtrasEstado
        from QPassTraslado a
        inner join Oficinas b
            on b.Ecodigo = a.Ecodigo
           and b.Ocodigo = a.OcodigoOri
        inner join Oficinas c
            on c.Ecodigo = a.Ecodigo
           and c.Ocodigo = a.OcodigoDest
        inner join Usuario d
            on d.Usucodigo = a.Usucodigo
        where a.Ecodigo = #session.Ecodigo#
        and a.QPTtrasEstado in (1,2)
        and a.QPTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.QPTid#">
        and exists(
                select 1
                from QPassUsuarioOficina f
                where f.Usucodigo = #session.Usucodigo#
                and  f.Ecodigo = #session.Ecodigo#
                and f.Ecodigo = c.Ecodigo
                and f.Ocodigo = c.Ocodigo
            )
    </cfquery>
</cfif>

<cf_templateheader title="SIF - Quick Pass">
	<cfinclude template="../../portlets/pNavegacion.cfm">
	<cf_web_portlet_start skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Recepción de Tags'>
		<cfoutput>
            <form name="form1" action="QPassRecepcion_SQL.cfm" method="post">
                <input name="QPTid" type="hidden" value="<cfif modo neq 'Alta'>#form.QPTid#</cfif>" tabindex="1"/>
                <input name="OcodigoOri" type="hidden" value="<cfif modo neq 'Alta'>#QPassTraslado.OcodigoOri#</cfif>" tabindex="1"/>
                <input name="OcodigoDest" type="hidden" value="<cfif modo neq 'Alta'>#QPassTraslado.OcodigoDest#</cfif>" tabindex="1"/>
            
            <cf_navegacion name="QPTid" default="" 	navegacion="navegacion">
                <table cellpadding="2" cellspacing="0" align="center" border="0" width="100%">
                    <tr>
                    	<td colspan="2" align="left">
                        	<strong>Sucursal Origen:&nbsp;</strong> #QPassTraslado.OficodigoOri#
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" align="left">
                        	<strong>Sucursal Destino:&nbsp;</strong> #QPassTraslado.OficodigoDest#
                        </td>
                    </tr>
                    <tr>
                    	<td colspan="2" align="left">
                        	<strong>Documento:</strong>&nbsp; #QPassTraslado.codigo# <cfif QPassTraslado.QPTtrasEstado LTE 1><input  name="btnBorrar" id="btnBorrar" type="image" onClick="javascript: return Borrar(#form.QPTid#);" src="../../imagenes/Borrar01_T.gif" width="16" height="16"></cfif>
                        </td>
                    </tr>
                    <tr>
                    	<td colspan="2" align="left">
                        	<strong>Descripci&oacute;n:</strong>&nbsp; #QPassTraslado.descripcion#
                        </td>
                    </tr>
                    <tr>
	                    <td colspan="2">&nbsp;</td>
                    </tr>
                    <tr>
	                    <td colspan="2">
                        	<cfflush interval="16">

                            <cf_navegacion name="QPTPAN" 	  default="" 	navegacion="navegacion">
                            <cf_navegacion name="QPLcodigo"   default="" 	navegacion="navegacion">
                            <cf_navegacion name="QPTNumSerie" default="" 	navegacion="navegacion">
                           
                            
                            <cfinvoke component="sif.Componentes.pListas" method="pListaRH"
                             returnvariable="pLista">
                               <cfinvokeargument name="tabla" 				value=" QPassTrasladoOfi a
                                                                                    inner join QPassTag b
                                                                                      on b.QPTidTag = a.QPTidTag 
                                                                                    inner join QPassLote c
                                                                                       on c.QPidLote = b.QPidLote"/>
                                <cfinvokeargument name="columnas" 			value=" b.QPTidTag,
                                                                                    b.QPTPAN, 
                                                                                    c.QPLcodigo,
                                                                                    b.QPTNumSerie "/>
                                <cfinvokeargument name="filtro" 			value=" a.QPTid = #form.QPTid#
																			        and QPTOEstado = 0 "/>
                                <cfinvokeargument name="desplegar" 			value="QPTPAN, QPLcodigo, QPTNumSerie"/>
                                <cfinvokeargument name="usaAJAX" 			value="no"/>
                                <cfinvokeargument name="conexion" 			value="#session.DSN#"/>
                                <cfinvokeargument name="etiquetas" 			value="TAG, Lote, Serie"/>
                                <cfinvokeargument name="formatos" 			value="S,S,S"/>
                                <cfinvokeargument name="align" 				value="left,left,left"/>
                                <cfinvokeargument name="ajustar" 			value="S"/>
                                <cfinvokeargument name="navegacion" 		value="#navegacion#"/>
                                <cfinvokeargument name="irA" 				value="QPassRecepcion_form.cfm"/>
                                <cfinvokeargument name="showLink" 			value="false"/>
                                <cfinvokeargument name="debug" 				value="N"/>
                                <cfinvokeargument name="Keys" 				value="QPTidTag"/>
                                <cfinvokeargument name="mostrar_filtro" 	value="True"/>
                                <cfinvokeargument name="filtrar_automatico" value="True"/> 
                                <cfinvokeargument name="filtrar_por" 		value="QPTPAN, QPLcodigo, QPTNumSerie"/>
                                <cfinvokeargument name="showEmptyListMsg" 	value="true"/>
                                <cfinvokeargument name="MaxRows" 			value="500"/>
                                <cfinvokeargument name="TabIndex" 			value="1"/>
                                <cfinvokeargument name="formname" 			value="form1"/>
                                <cfinvokeargument name="checkboxes" 		value="S"/>
                                <cfinvokeargument name="checkall" 			value="S"/>
                                <cfinvokeargument name="botones" 			value="Aceptar_Traslado, Regresar"/>
                            </cfinvoke>	
                        
                        </td>
                    </tr>
                </table>
           </form>
        </cfoutput>
    <cf_web_portlet_end>
<cf_templatefooter>

<script language="JavaScript1.2" type="text/javascript">


	function Borrar(id) {
		var f = document.form1;
		f.QPTid.value = id;	
		document.form1.onsubmit="";
		return (confirm('¿Está seguro de eliminar este documento?'))
	}
	
	function funcRegresar(){
			document.form1.action = 'QPassRecepcion.cfm';
			document.form1.submit();
		}

	function funcAceptar_Traslado(){
		if (!algunoMarcado(document.form1)){
			alert('Debe marcar uno o más Tags, de la lista de Tags enviados, para poder aceptarlo.');
			return false;
		}
	}

	function algunoMarcado(f) {
		if (f.chk) {
			if (f.chk.value) {
				return (f.chk.checked);
			} else {
				for (var i=0; i<f.chk.length; i++) {
					if (f.chk[i].checked) return true;
				}
			}
		}
		return false;
	}
</script>