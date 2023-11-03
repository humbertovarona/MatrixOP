unit Matriz;

interface
  uses Classes;

  type
    TMatriz = Class
      protected
         A: TList;

      public
         constructor Create;
         procedure Clear;
         procedure Add(item: TList);
         procedure Assign(M: TMatriz);
         procedure InittoIdenty(N: word);
         function  Inverse(M: TMatriz): boolean;
         procedure InitToCero(N: word);
         procedure ChangeRow(row1,row2: integer);
         function  GetValue(fila, col: Integer): double;
         procedure SetValue(fila,col: integer; Value:Double);
         procedure Sum(M1,M2: TMatriz);
         procedure Mul(M1,M2: TMatriz);
         procedure MulEscalar(b: double);
      end;


implementation

constructor TMatriz.Create;
begin
  inherited Create;
  A:= Tlist.Create;
  A.Capacity:= 0;
end;

procedure TMatriz.Clear;
var
  i: integer;
begin
  for i:= 0 to A.count-1 do
    TList(A.items[i]^).Clear;
  A.Clear
end;

procedure TMatriz.Add(item: TList);
var
 p: ^TList;
begin
  new(P);
  P^:= Item;
  A.Capacity:= A.Capacity +1;
  A.add(P)
end;

procedure TMatriz.Assign(M: TMatriz);
var
  i,j: integer;
begin
  InitToCero(M.A.Count);
  for i:= 0 to M.A.Count-1 do
    for j:= 0 to M.A.Count-1 do
     Setvalue(i,j,M.GetValue(i,j));
end;

procedure TMatriz.InittoIdenty(N: word);
var
  i,j: integer;
  p:^double;
  tem: Tlist;
begin
  Clear;
  A.Capacity:= N;
  for i:= 1 to N do
  begin
    Tem:= Tlist.Create;
    for j:= 1 to N do
    begin
      new(P);
      if j = i then P^:= 1
      else P^:= 0;
      tem.add(P);
    end;
    Add(Tem)
  end
end;

procedure TMatriz.ChangeRow(row1,row2: integer);
var
  Q: Tlist;
begin
  Q:= Tlist(A.Items[row1]^);
  Tlist(A.items[row1]^):= Tlist(A.items[row2]^);
  Tlist(A.items[row2]^):= Q
end;

function TMatriz.Inverse(M: TMatriz): boolean;
var
  i,j,k: integer;
  Tem: TList;
  p: ^Double;
  factor: double;
begin
  Tem:= Tlist.Create;
  Tem.Capacity:= M.A.Count;
  for i:= 1 to M.A.Count-1 do
  begin
    New(P);
    P^:= M.GetValue(i,i);
    if P^ = 0 then
     begin
       result:= false;
       Exit;
     end;
    Tem.Add(P);
  end;
  InittoIdenty(M.A.Count);
  //Simular
   {  M11    Mij
         Mii
      0     Mnn   }
  // Haciendo tramsformaciones en la matriz identidad

  for k:= 0 to A.Count-2 do
   for i:= k+1 to A.Count-1 do
    begin
      factor := M.GetValue(i,k)/M.GetValue(k,k);
      for j:= 0 to M.A.Count-1 do
       double(Tlist(A.Items[i]^).Items[j]^):= double(Tlist(A.Items[i]^).Items[j]^)- factor*double(Tlist(A.Items[k]^).Items[j]^);
      Double(tem.items[i]^):= double(Tem.items[i]^) - factor*M.getValue(k,j)
    end;
  //Simular
   {  M11     0
         Mii
      0     Mnn   }
  // Haciendo tramsformaciones en la matriz identidad

  for k:= A.Count-1 downto 1 do
   if double(tem.items[k]^) <> 0 then
      for i:= k-1 downto 0 do
       begin
         factor := M.GetValue(i,k)/Double(tem.items[k]^);
         for j:= k downto 0 do
         double(Tlist(A.Items[i]^).Items[j]^):= double(Tlist(A.Items[i]^).Items[j]^)- factor*double(Tlist(A.Items[k]^).Items[j]^)
       end
    else begin
          result:= false;
          exit;
         end;
  for i:= 0 to A.count -1 do
   for j:= 0 to A.Count -1 do
    double(Tlist(A.items[i]^).items[j]^):= getvalue(i,j)/double(tem.items[i]^);
   result:= true;
end;

procedure TMatriz.InitToCero(N: word);
var
 i, j: integer;
 p: ^double;
 tem: Tlist;
begin
  Clear;
  for i:= 1 to N do
  begin
    Tem:= Tlist.Create;
    for j:= 1 to N do
    begin
      new(P);
      P^:= 0;
      tem.add(P);
    end;
    Add(Tem)
  end
end;

function TMatriz.GetValue(fila, col: Integer): Double;
begin
  result:= double(Tlist(A.items[fila]^).items[col]^);
end;

procedure TMatriz.SetValue(fila,col: integer; Value:Double);
begin
  Double(Tlist(A.Items[fila]^).items[Col]^):= Value
end;

procedure TMatriz.Sum(M1,M2: TMatriz);
var
  i,j: Integer;
begin
  InitToCero(M1.A.Count);
  for i:= 0 to A.count-1 do
   for j:= 0 to A.Count-1 do
    SetValue(i,j, M1.GetValue(i,j)+ M2.GetValue(i,j))
end;

procedure TMatriz.Mul(M1,M2: TMatriz);
var
 i,j,k: integer;
 sum: double;
begin
  if M1.A.Count = M2.A.Count then
   begin
    InittoCero(M1.A.Count);
    for i:= 0 to M1.A.count-1 do
     for j:= 0 to M1.A.Count-1 do
      begin
        sum:= 0;
        for k:= 0 to M1.A.Count do
          Sum:= Sum + M1.GetValue(i,k)* M2.GetValue(K,j);
        double(Tlist(A.items[i]^).Items[j]^):= Sum
      end;
   end
end;

procedure TMatriz.MulEscalar(b: double);
var
 i,j: integer;
begin
  for i:= 0 to A.count-1 do
   for j:= 0 to A.count -1 do
    SetValue(i,j,GetValue(i,j)*b)
end;

end.
