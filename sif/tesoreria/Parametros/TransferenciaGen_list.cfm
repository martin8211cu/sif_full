<table width="90%" align="center" border="0">
		<tr>
		<td valign="top" align="left">

<cfset checked   = "<img border='0' src='/cfmx/sif/imagenes/checked.gif' style='cursor:pointer;'	" >
<cfset unchecked = "<img border='0' src='/cfmx/sif/imagenes/unchecked.gif' style='cursor:pointer;'	" >

<cf_dbfunction name="OP_concat" returnvariable="_cat">
<cfquery datasource="#session.dsn#" name="lista">
	select 	TESTGid, TESTGdescripcion,
			case TESTGcodigoTipo
				when 0 then 
					case TESTGtipoCtas
						when 0 then 'Cualquier cuenta de cualquier Bco&nbsp;&nbsp;'
						when 1 then 'Ctas Propias de Mismo Bco de Pago&nbsp;&nbsp;'
						when 2 then 'Ctas Interbancarias de otros Bcos&nbsp;&nbsp;'
						when 3 then 'Ctas Interbancarias cualquier Bco&nbsp;&nbsp;'
						when 4 then 'Ctas propias e Interbancarias&nbsp;&nbsp;'
					end
				when 1 then 'Cuentas ABA'
				when 2 then 'Cuentas SWIFT'
				when 3 then 'Cuentas IBAN'
				else 'Cuentas Especiales'
			end as TIPO,
			case TESTGtipoConfirma
				when 1 then 'Por Lote'
				when 2 then 'Por O.P.'
			end as CONFIRMA
			,case when TESTGactivo = 1 
				then <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#checked#">
				else <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#unchecked#">
			end #_cat# ' onclick="sbMarcar(' #_cat# <cf_dbfunction name="to_char" args="TESTGid"> #_cat# ');">' 
			as marcado		
	from TEStransferenciaG
</cfquery>

<cfinvoke 	component="sif.Componentes.pListas" method="pListaQuery"
			query="#lista#"
			desplegar="marcado,TESTGdescripcion,TIPO,CONFIRMA"
			etiquetas=" ,Descripcion, Tipo de Cuentas Destino, Confirmacion"
			formatos="S,S,S,S"
			align="left,left,left,left"
			ajustar="N"
			ira=""
			keys="TESTGid"
			showEmptyListMsg="yes"
			EmptyListMsg="--- No se existen Parámetros definidos ---"
			showLink="yes"
			checkboxes="N"
			formName="formLista"
/>		
		</td>
	</tr>
</table>
<script language="javascript">
	function sbMarcar(id)
	{
		location.href="TransferenciaGen.cfm?OP=chk&id=" + id;
		document.formLista.nosubmit=true;
	}
</script>
