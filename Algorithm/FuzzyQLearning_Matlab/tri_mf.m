function val=tri_mf(a,b,c,x,type)
  switch type
      case 'tria'
          val= max(min((x-(a))/((b)-(a)),((c)-x)/((c)-(b))),0);
      case 'end'
          val= min(max((x-a)/(b-a),0),1);
      case 'start'
          val= max(min((b-x)/(b-a),1),0);
  end
end