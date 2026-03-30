<cfinclude template="../Application.cfm">
<cfinclude template="../Utiles/fnDateDiff.cfm">
<cfset session.debug = true>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>
<strong>EJECUTANDO LA FUNCION BalanceMoneda</strong><br>
<cfset timeinit = Now()>
Tiempo de Inicio:&nbsp; <cfoutput>#LSTimeFormat(timeinit,"hh:mm:ss:l")#</cfoutput><br>
<cfinvoke 
 component="sif.Componentes.Contabilidad"
 method="Balance_Moneda">
	<cfinvokeargument name="Cconcepto" value="1"/>
	<cfinvokeargument name="Eperiodo" value="2003"/>
	<cfinvokeargument name="Emes" value="2"/>
	<cfinvokeargument name="Edocumento" value="10"/>
</cfinvoke>
<cfset timefin = Now()>
Tiempo de Finalización:&nbsp; <cfoutput>#LSTimeFormat(timefin,"hh:mm:ss:l")#</cfoutput><br>
Tiempo de ejecución en milisegundos:&nbsp; <cfoutput>#fnDateDiff('l',timeinit,timefin)#</cfoutput><br>

<strong>RETORNA:&nbsp;<cfoutput>##</cfoutput></strong><br>

<strong>TEXTO DEL SP</strong><br>

<table width="100%"  border="1" cellspacing="1" cellpadding="1">
  <tr>
    <td>if exists (select 1<br>
from sysobjects<br>
where id = object_id('CG_BalanceMoneda')<br>
and type = 'P')<br>
drop procedure CG_BalanceMoneda<br>
go
<p>&nbsp;</p>
<p>create procedure CG_BalanceMoneda<br>
  @IDcontable numeric,<br>
  @Ecodigo int,<br>
  @Cconcepto int,<br>
  @Eperiodo smallint,<br>
  @Emes smallint,<br>
  @Edocumento int<br>
  as</p>
<p>declare<br>
  @cre numeric(20,4),<br>
  @deb numeric(20,4),<br>
  @des varchar(60),<br>
  @msg varchar(100),<br>
  @moneda numeric,<br>
  @diferencia numeric(20,4),<br>
  @oficina int</p>
<p>&lt;!---1---&gt;</p>
<p>if @IDcontable is null begin<br>
  select @IDcontable = IDcontable<br>
  from EContables<br>
  where Ecodigo = @Ecodigo<br>
  and Cconcepto = @Cconcepto<br>
  and Eperiodo = @Eperiodo<br>
  and Emes = @Emes<br>
  and Edocumento = @Edocumento<br>
  end</p>
<p>&lt;!---2---&gt;</p>
<p>select @cre = 0 , @deb = 0</p>
<p>declare nav cursor for <br>
  select distinct Ocodigo,Mcodigo<br>
  from DContables<br>
  where IDcontable = @IDcontable</p>
<p>&lt;!---3---&gt; </p>
<p>open nav<br>
  fetch nav into @oficina, @moneda</p>
<p>while @@sqlstatus = 0<br>
  begin<br>
  select @cre = isnull((select sum(Doriginal) from DContables<br>
  where IDcontable = @IDcontable<br>
  and Ecodigo = @Ecodigo<br>
  and Cconcepto = @Cconcepto<br>
  and Eperiodo = @Eperiodo<br>
  and Emes = @Emes<br>
  and Edocumento = @Edocumento<br>
  and Ocodigo = @oficina<br>
  and Mcodigo = @moneda<br>
  and Dmovimiento = &quot;C&quot;),0)</p>
<p> select @deb = isnull((select sum(Doriginal) from DContables<br>
  where IDcontable = @IDcontable<br>
  and Ecodigo = @Ecodigo<br>
  and Cconcepto = @Cconcepto<br>
  and Eperiodo = @Eperiodo<br>
  and Emes = @Emes<br>
  and Edocumento = @Edocumento<br>
  and Ocodigo = @oficina<br>
  and Mcodigo = @moneda<br>
  and Dmovimiento = &quot;D&quot;),0)</p>
<p> select @diferencia = round(@cre - @deb,2)<br>
  if @diferencia != 0.00<br>
  begin<br>
  select @des = Mnombre from Monedas where Mcodigo = @moneda<br>
  select @msg = &quot;Los montos en la moneda &quot; + @des + &quot; no concuerdan para la sucursal &quot; + Odescripcion<br>
  from Oficinas<br>
  where Ecodigo = @Ecodigo<br>
  and Ocodigo = @oficina<br>
  close nav<br>
  deallocate cursor nav<br>
  raiserror 40000 @msg <br>
  return -1<br>
  end<br>
  fetch nav into @oficina, @moneda<br>
  end<br>
  close nav<br>
  deallocate cursor nav<br>
  return<br>
  go<br>
  exec sp_procxmode CG_BalanceMoneda , anymode<br>
  go</p></td>
  </tr>
</table>
</body>
</html>
