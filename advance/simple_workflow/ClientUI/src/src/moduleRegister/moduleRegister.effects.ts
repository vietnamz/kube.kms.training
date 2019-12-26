import { RouterEffects } from '../app/router.effects'
import { WorkFlowEffects } from '../components/workFlow/workFlow.effects';
import {LoginEffects} from '../components/login/login.effects';

export const Effects = [RouterEffects, WorkFlowEffects, LoginEffects];