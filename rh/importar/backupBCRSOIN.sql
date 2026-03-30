select  a.DRIdentificacion
 || char(9)
 || a.DRNapellido1
 || ' '
 || a.DRNapellido2
 || ' '
 || a.DRNnombre
 || char(9)
 || convert(varchar, convert(int,substring(a.CBcc, 6, 3)))
 || '-'
 || substring(a.CBcc, 9, datalength(rtrim(a.CBcc))-9)
 || char(9)
 || convert(varchar,DRNliquido) as datos
from DRNomina a, ERNomina b
where a.ERNid=@ERNid
and b.ERNid=@ERNid
and b.Ecodigo=@Ecodigo
and a.ERNid=b.ERNid
and a.Bid=@Bid
and datalength(rtrim(a.CBcc)) > 9