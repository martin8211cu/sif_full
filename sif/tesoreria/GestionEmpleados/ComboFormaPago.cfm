<cfsetting enablecfoutputonly="yes">

<cfif isdefined ('url.CFid') and #url.CFid# GT 0>
    <cfquery  name="rsCajaChica" datasource="#session.dsn#">
		select 	distinct
				c.CCHtipo,
				c.CCHid,
				c.CCHdescripcion,
				c.CCHcodigo
		from CCHica c
			inner join CCHicaCF cf
			on cf.CCHid=c.CCHid
		where c.Ecodigo=#session.Ecodigo#
		  and c.CCHestado='ACTIVA'
		  and c.Mcodigo=#url.McodigoOri#
          and cf.CFid=#url.CFid#
		  and c.CCHtipo<>3
		order by c.CCHtipo desc
	</cfquery>
	<cfoutput>
	<select name="FormaPago" id="FormaPago">
		<option value="" >(Seleccionar Forma de Pago)</option>
		<optgroup label="Por Tesorería">
		<option value="0" <cfif url.CCHid EQ 0> selected= "selected" </cfif>>Cheque o TEF</option>
	</cfoutput>
	<cfif rsCajaChica.RecordCount>
		<cfoutput query="rsCajaChica" group="CCHtipo">
			<cfif CCHtipo EQ 1>
				<optgroup label="Por Caja Chica">
			<cfelse>
				<optgroup label="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Con Efectivo por Caja Especial">
			</cfif>
			<cfoutput>
			<option value="#rsCajaChica.CCHid#" <cfif rsCajaChica.CCHid eq url.CCHid> selected="selected" </cfif>>#rsCajaChica.CCHcodigo#-#rsCajaChica.CCHdescripcion#</option>									
			</cfoutput>
		</cfoutput>
		</optgroup>
	</cfif>
	<cfoutput>
	</select>					                             
	</cfoutput>
<cfelse>
	<cfoutput>
	<select name="FormaPago" id="FormaPago">
		<option value="" >(Debe Seleccionar Centro Funcional)</option>
	</select>
	</cfoutput>
</cfif>
