<!---<

Poner datos de prueba aleatorios.
	declare @indicador varchar (30), @valor numeric(12,2)
	select @indicador = ' ', @valor = rand() * 200
	update MonEmpresaStats set valor = 0
	set nocount on set rowcount 1
	while (1=1) begin
		select @indicador = min(indicador) from MonEmpresaStats where indicador > @indicador
		if @indicador is null break
		while (1=1) begin
			update MonEmpresaStats set valor = @valor where valor = 0 and indicador = @indicador
			if @@rowcount = 0 break
			select @valor = @valor * ( 0.8  + rand() * 0.4 )
		end
	end
	set rowcount 0 set nocount off
	select * from MonEmpresaStats 

>--->
<!--- Recálculo de indicadores del día --->
<cfloop from="0" to="0" index="i">
	<cfinvoke component="asp.admin.empresa.indicador.calculo" method="calcular"
		Ecodigo="#url.emp#" fecha="#DateAdd('d', -i, Now())#" />
</cfloop>

<cfquery datasource="asp" name="ctae_q">
	select CEcodigo, CEnombre
	from CuentaEmpresarial
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ctae#">
</cfquery>
<cfquery datasource="asp" name="emp_q">
	select e.Ecodigo, e.Enombre, c.Ccache, e.Ereferencia
	from Empresa e
			join Caches c
				on e.Cid = c.Cid
			join CuentaEmpresarial ce
				on ce.CEcodigo = e.CEcodigo
		where e.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ctae#">
		  and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.emp#">
</cfquery>
<cfset col_fecha = "case
	when datediff (dd, fecha, getdate()) < 15 then fecha
	when datediff (dd, fecha, getdate()) < 365 then dateadd(dd, 1-datepart(dd, fecha), fecha)
	else dateadd(dy, 1-datepart(dy, fecha), fecha) end">
<cfquery datasource="aspmonitor" name="indicadores">
	select indicador, #col_fecha# as fecha, avg(valor) as valor
	from MonEmpresaStats
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.emp#">
	  and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ctae#">
	group by indicador, #col_fecha#
	order by indicador, #col_fecha#
</cfquery>

<cfcontent reset="yes">
<cf_templateheader title="Detalle de la empresa">

<cf_web_portlet_start titulo="Detalle de la empresa">

<table border="0" cellspacing="0" cellpadding="2" width="877">
  <tr>
    <td width="20" class="subTitulo">&nbsp;</td>
    <td width="20" class="subTitulo">&nbsp;</td>
    <td width="60" class="subTitulo">&nbsp;</td>
    <td width="187" class="subTitulo">&nbsp;</td>
    <td width="328" class="subTitulo">&nbsp;</td>
    <td width="112" class="subTitulo">&nbsp;</td>
  </tr>
  <tr>
    <td colspan="6" class="subTitulo"><cfoutput>#HTMLEditFormat(emp_q.Enombre)#</cfoutput></td>
    </tr>
<cfoutput>
  <tr>
    <td>&nbsp;</td>
    <td colspan="2" valign="top"><img src="../../../home/public/logo_empresa.cfm?EcodigoSDC=#URLEncodedFormat( url.emp )#" alt="logotipo" height="60"/></td>
    <td valign="top">#HTMLEditFormat(ctae_q.CEnombre)#</td>
    <td valign="top"><table border="0" cellspacing="2" cellpadding="2">
      <tr>
        <td width="199">Oficinas</td>
        <td width="73">65</td>
      </tr>
      <tr>
        <td>Centros Funcionales </td>
        <td>98</td>
      </tr>
      <tr>
        <td>Empleados</td>
        <td>72</td>
      </tr>
      
    </table></td>
    <td valign="top">&nbsp;</td>
  </tr>
</cfoutput>	<cfoutput query="indicadores" group="indicador">
  <tr>
    <td>&nbsp;</td>
    <td class="subTitulo" colspan="5">#HTMLEditFormat(  REReplace(indicadores.indicador, '(.)(.+)', '\U\1\L\2'))#</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td colspan="4" align="right">
	<cfset ultimoValor = ''>
	<cfoutput><cfset ultimoValor = valor></cfoutput>
	<cfif Len(ultimoValor)>
		<em>Valor m&aacute;s reciente: #NumberFormat(ultimoValor, '0.00')#</em>
	</cfif>	</td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td colspan="4">
	<cfchart chartwidth="800" chartheight="150" format="png">
		<cfchartseries type="line">
		<cfoutput>
		<cfif DateDiff('d', fecha, Now()) LT 15>
			<cfset ffecha = DateFormat(fecha, 'd-mmm')>
		<cfelseif DateDiff('d', fecha, Now()) LT 365>
			<cfset ffecha = DateFormat(fecha, 'mmm')>
		<cfelse>
			<cfset ffecha = DateFormat(fecha, 'yyyy')>
		</cfif>
		<cfchartdata item="#ffecha#" value="# NumberFormat(valor, '0.00') #">
		</cfoutput>
		</cfchartseries>
	</cfchart>	</td>
    </tr></cfoutput>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td colspan="4">&nbsp;</td>
  </tr>
</table>
<cf_web_portlet_end>
<cf_templatefooter>