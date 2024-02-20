// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../urchin_game.dart' as _i6;
import '../worlds/demo/demo_world.dart' as _i3;
import '../worlds/game_engine/first_world.dart' as _i4;
import '../worlds/menu/menu_world.dart' as _i5;
import '../worlds/worlds.dart' as _i7;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.singleton<_i3.DemoWorld>(_i3.DemoWorld());
    gh.singleton<_i4.FirstWorld>(_i4.FirstWorld());
    gh.singleton<_i5.MenuWorld>(_i5.MenuWorld());
    gh.factory<_i6.UrchinGame>(() => _i6.UrchinGame(
          gh<_i7.DemoWorld>(),
          gh<_i7.MenuWorld>(),
          gh<_i7.FirstWorld>(),
        ));
    return this;
  }
}