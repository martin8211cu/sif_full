<cfset navegacion = "">
<cfset EL	= '<a href="javascript: borraDet(AAAA);"><img border="0" src="/cfmx/sif/imagenes/Borrar01_S.gif"></a>'>
<cfset EL	= replace(EL,"'","''","ALL")>
<cfset EL	= replace(EL,"AAAA","' + convert( varchar, a.QPTidTag )  + '","ALL")>

<table width="98%" align="center"  border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td>&nbsp;</td>
    </tr>
    <tr>
        <td>&nbsp;</td>
    </tr>		
    <tr>
        <td>&nbsp;</td>
    </tr>
    <tr>
        <td>&nbsp;</td>
    </tr>
    <tr><td colspan="4"><hr></td></tr><tr>
    </tr>
    <tr>
        <td>&nbsp;</td>
    </tr>
    <tr>
        <td>&nbsp;</td>
    </tr>		
    <tr>
        <td>&nbsp;</td>
    </tr>
    <tr>
        <td>&nbsp;</td>
    </tr>
</table>
<cfquery name="rsEnc" datasource="#session.dsn#">
    select 
        a.QPEAPid,
        a.QPEAPDocumento,
        a.QPEAPDescripcion,
        b.Usulogin,
        c.QPPcodigo,
        c.Ocodigo
    
    from QPEAsignaPromotor a
    inner join Usuario b
        on b.Usucodigo = a.Usucodigo
    inner join QPPromotor c
        on c.QPPid = a.QPPid
    where  c.QPPestado = '1'
    and a.QPEAPEstado = 0
    and exists(
                select 1
                from QPassUsuarioOficina f
                where f.Usucodigo = #session.Usucodigo#
                and  f.Ecodigo = #session.Ecodigo#
                and f.Ecodigo = c.Ecodigo
                and f.Ocodigo = c.Ocodigo
                )
</cfquery>

<cfquery name="rsLista" datasource="#session.dsn#">
    select 
        a.QPTidTag, 
        l.QPLcodigo,
        '#PreserveSingleQuotes(EL)#' as eli,
        a.QPTPAN, 
        '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' as espacio,
        a.QPTNumSerie
    from QPassTag a
        inner join QPassLote l
         on a.QPidLote = l.QPidLote
        inner join QPDAsignaPromotor b
         on a.QPTidTag  =b.QPTidTag 
    where a.Ecodigo = #session.Ecodigo#
        and a.Ocodigo = #rsEnc.Ocodigo#
        and a.QPTEstadoActivacion=9 <!--- Asignado Promotor --->
        and b.QPEAPid = #form.QPEAPid#	
</cfquery>	
<cfoutput>		
	<form action="TagPromotores_SQL.cfm" method="post" name="form1"> 
		<input type="hidden" name="QPEAPid" value="#form.QPEAPid#" >
		<input type="submit"  value="QPTidTag" name="BorrarDet" id="BorrarDet" style="display:none"/>
		
		<cfset LvarBoton =''>
		<cfquery name="rsVerificaDato" datasource="#session.dsn#">
			select count(1) as cantidad 
            from QPDAsignaPromotor
			where QPEAPid = #form.QPEAPid#	
		</cfquery>
		<cfif #rsVerificaDato.cantidad# gt 0>
			<cfset LvarBoton ='Aceptar'>
		<cfelse>
			<cfset LvarBoton =''>
		</cfif>
		
		
	<fieldset><legend><strong>Promotor Destino</strong></legend>
		<cfinvoke
			component="sif.Componentes.pListas"
			method="pListaQuery"
			returnvariable="rsLista"
			showLink = "no"
			query="#rsLista#"
			columnas="QPTPAN,espacio, espacio,QPLcodigo,espacio, espacio,eli,"
			desplegar="QPTPAN,espacio,espacio, QPLcodigo,espacio, espacio,eli"
			etiquetas="TAG, , ,Lote, , ,Eliminar"
			formatos="S,S,S,S,S,S,S"
			align="left,left,left,left,left,left,left"
			irA="TagPromotores.cfm"
			keys="QPTidTag"
			navegacion="#navegacion#" 				 
			showEmptyListMsg= "true"
			formname= "form1"
			incluyeForm ="false"
			botones = "#LvarBoton#"
			maxrows="50"
			/>
		</form>
	</fieldset>
</cfoutput> 

<cfoutput>
<cf_qforms form="form1">
	<script language="javascript1.2" type="text/javascript">
	
		function Valida(){
			return confirm('¿Está seguro(a) de que desea eliminar el registro?')
		}
		
		function borraDet(QPTidTag){		
			if (Valida()){
				document.form1.BorrarDet.value = QPTidTag;
				document.form1.BorrarDet.click();
			}			
		}
		
		function funcAceptar(){
		var PARAM  = "Comprobante_Asignacion.cfm?QPEAPid=#form.QPEAPid#"
		window.open(PARAM,'','left=250,top=250,scrollbars=yes,resizable=yes,width=600,height=400')
		return true;
		}

	</script>
</cfoutput>
