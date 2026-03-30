 <cfquery name="rsQPTAG" datasource="#session.DSN#">
        select
		QPTidTag,
		QPTlista,
        QPTNumParte,
        QPTFechaProduccion,
        QPTNumSerie,
        QPTPAN,
        QPTNumLote,
        QPTNumPall,
        QPTEstadoActivacion,
        QPidEstado,
        QPidLote
        from QPassTag
        where Ecodigo = #session.Ecodigo#
		<cfif len(trim(url.QPTidTag)) gt 0>
       		 and QPTidTag = #url.QPTidTag#
		</cfif>
       and QPTEstadoActivacion in (1,2,7,9)
    </cfquery>

<cfquery datasource="#Session.DSN#" name="rsEst">
    select QPEdisponibleVenta
    from QPassEstado 
		 where Ecodigo = #session.Ecodigo#
		and QPidEstado = #url.QPidEstado#
</cfquery>
<cfoutput>

	<cfif rsEst.QPEdisponibleVenta neq 1>
	 " El estado no está disponible<br> para venta, por tanto quedará<br> en lista <strong> Negra </strong>"
	<cfelse>
	<select name="QPTlista" tabindex="1">
		<option value="B" <cfif rsQPTAG.QPTlista eq 'B'>selected="selected"</cfif>>Blanca</option>
		<option value="G" <cfif rsQPTAG.QPTlista eq 'G'>selected="selected"</cfif>>Gris</option>
		<option value="N" <cfif rsQPTAG.QPTlista eq 'N' and rsEst.QPEdisponibleVenta neq 1>selected="selected"</cfif>>Negra</option>
	</select>
</cfif>
</cfoutput>

